//
//  _RNSComponentHandler.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "_RNSComponentHandler.h"
#import "_RNSComponentViewPool.h"
#import "UIView + RNSComponent.h"
#import "NSObject + RNSComponent.h"

@interface _RNSComponentHandler()
@property(nonatomic, strong, readwrite) NSDictionary<NSString *, NSObject<RNSModelProtocol> *> *componentItemDic;
@property(nonatomic, strong, readwrite) NSMutableDictionary<NSString *, __kindof UIView *> *dequeueViewsDic;
@property(nonatomic, strong, readwrite) NSMutableArray <__kindof UIView *>* scrollViewSubViews;
@property(nonatomic, copy, readwrite) RNSComponentViewStateChangeBlock changeBlock;
@property(nonatomic, weak, readwrite) __kindof UIScrollView * scrollView;
@end

@implementation _RNSComponentHandler

- (instancetype)initWithScrollView:(__kindof __weak UIScrollView *)scrollView
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock{
    self = [super init];
    if (self) {
        _componentItemDic = @{};
        _dequeueViewsDic = @{}.mutableCopy;
        _scrollViewSubViews = @[].mutableCopy;
        _scrollView = scrollView;
        _changeBlock = componentViewStateChangeBlock;
    }
    return self;
}

-(void)dealloc{
    self.componentItemDic = nil;
    
    [self.dequeueViewsDic removeAllObjects];
    self.dequeueViewsDic = nil;
    
    for (__kindof UIView * subView in self.scrollViewSubViews) {
        [subView removeFromSuperview];
    }
    [self.scrollViewSubViews removeAllObjects];
    self.scrollViewSubViews = nil;
    
    self.changeBlock = nil;
    self.scrollView = nil;
    
}

#pragma mark - public method

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock{
    
    if ([NSThread isMainThread]) {
        if(processBlock){
            _componentItemDic = [processBlock(_componentItemDic) copy];
        }
        
        [self detailComponentsDidUpdateWithOffsetTop:self.scrollView.contentOffset.y forceLayout:YES];
    }else{
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself reloadComponentViewsWithProcessBlock:processBlock];
        });
    }
}

#pragma mark - public method

- (NSObject<RNSModelProtocol> *)getComponentItemByUniqueId:(NSString *)uniqueId{
    if (!uniqueId || uniqueId.length <= 0 || !self.componentItemDic || self.componentItemDic.count <= 0) {
        return nil;
    }
    return [self.componentItemDic objectForKey:uniqueId];
}

- (__kindof UIView *)getComponentViewByItem:(NSObject<RNSModelProtocol> *)item{
    if(!item || !self.dequeueViewsDic || self.dequeueViewsDic.count <= 0){
        return nil;
    }
    return [self.dequeueViewsDic objectForKey:[item getUniqueId]];
}

- (NSArray <NSObject<RNSModelProtocol> *> *)getVisiableComponentItems{
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }
    
   return  [self.componentItemDic.allValues objectsAtIndexes:
     [self.componentItemDic.allValues indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
       if ([obj conformsToProtocol:@protocol(RNSModelProtocol)]) {
           return ((NSObject<RNSModelProtocol> *)obj).newState == kRNSComponentStateVisible;
       }
       return NO;
    }]];

}

- (NSArray <NSObject<RNSModelProtocol> *> *)getPreparedComponentItems{
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }

    return [self.componentItemDic.allValues objectsAtIndexes:
             [self.componentItemDic.allValues indexesOfObjectsPassingTest:^BOOL(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(RNSModelProtocol)]) {
            return ((NSObject<RNSModelProtocol> *)obj).newState == kRNSComponentStatePrepare;
        }
        return NO;
    }]];
}

- (NSArray <NSObject<RNSModelProtocol> *>*)getAllComponentItemsWithorderByOffset:(BOOL)orderByOffset{
    
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return @[];
    }
    
    if(orderByOffset){
        return [self.componentItemDic.allValues sortedArrayUsingComparator:^NSComparisonResult(NSObject<RNSModelProtocol> *item1,
                                                                                               NSObject<RNSModelProtocol> *item2) {
            if ([item1 getComponentFrame].origin.y  < [item2 getComponentFrame].origin.y ){
                return (NSComparisonResult)NSOrderedAscending;
            }else{
                return (NSComparisonResult)NSOrderedDescending;
            }
        }];
    }else{
        return self.componentItemDic.allValues;
    }
}

#pragma mark -

- (void)detailComponentsDidUpdateWithOffsetTop:(CGFloat)offsetTop forceLayout:(BOOL)forceLayout{
    
    
    if (!self.componentItemDic || self.componentItemDic.count <= 0) {
        return;
    }
    
    CGFloat visibleTopLine = offsetTop;
    CGFloat visibleBottomLine = offsetTop + self.scrollView.frame.size.height;
    
    CGFloat preparedTopLine = visibleTopLine - self.componentWorkRange;
    CGFloat preparedBottomLine = visibleBottomLine + self.componentWorkRange;
    
    for (NSObject<RNSModelProtocol> *item in self.componentItemDic.allValues) {
        //in prepare
        if ([item getComponentFrame].origin.y + [item getComponentFrame].size.height > preparedTopLine && [item getComponentFrame].origin.y < preparedBottomLine) {
            //in visible
            if ([item getComponentFrame].origin.y + [item getComponentFrame].size.height > visibleTopLine && [item getComponentFrame].origin.y < visibleBottomLine) {
                item.newState = kRNSComponentStateVisible;
            }else{
                item.newState = kRNSComponentStatePrepare;
            }
        }else{
            item.newState = kRNSComponentStateNone;
        }
    }
    
    for (NSObject<RNSModelProtocol> *item in self.componentItemDic.allValues) {
        if(item.newState == item.oldState){
            if (forceLayout && item.newState != kRNSComponentStateNone) {
                __kindof UIView *view = [self getComponentViewByItem:item];
                view.frame = [item getComponentFrame];
                [self _triggerComponentEvent:kRNSComponentViewReLayoutPreparedAndVisibleComponentView withItem:item];
            }
            continue;
        }
        
        if(item.newState == kRNSComponentStateVisible && item.oldState == kRNSComponentStatePrepare){
            
            [self _triggerComponentEvent:kRNSComponentViewWillDisplayComponentView withItem:item];
            
        }else if (item.newState == kRNSComponentStateVisible && item.oldState == kRNSComponentStateNone){
            
            __kindof UIView *view = [self _dequeueViewOfItem:item];
            [_scrollView addSubview:view];
            [_scrollViewSubViews addObject:view];
            
            [self _triggerComponentEvent:kRNSComponentViewWillPreparedComponentView withItem:item];
            [self _triggerComponentEvent:kRNSComponentViewWillDisplayComponentView withItem:item];
            
            
        }else if (item.newState == kRNSComponentStatePrepare && item.oldState == kRNSComponentStateNone){
            
            [self _dequeueViewOfItem:item];
            __kindof UIView *view = [self _triggerComponentEvent:kRNSComponentViewWillPreparedComponentView withItem:item];
            [_scrollView addSubview:view];
            [_scrollViewSubViews addObject:view];
            
        }else if (item.newState == kRNSComponentStatePrepare && item.oldState == kRNSComponentStateVisible){
            
            [self _triggerComponentEvent:kRNSComponentViewEndDisplayComponentView withItem:item];
            
        }else if (item.newState == kRNSComponentStateNone && item.oldState == kRNSComponentStatePrepare){
            
            [self _triggerComponentEvent:kRNSComponentViewEndPreparedComponentView withItem:item];
            [self _enqueueViewOfItem:item];
            
        }else if (item.newState == kRNSComponentStateNone && item.oldState == kRNSComponentStateVisible){
            
            [self _triggerComponentEvent:kRNSComponentViewEndDisplayComponentView withItem:item];
            [self _triggerComponentEvent:kRNSComponentViewEndPreparedComponentView withItem:item];
            [self _enqueueViewOfItem:item];
            
        }else{
            //never
        }
        
        item.oldState = item.newState;
    }
}


#pragma mark - private method of

- (__kindof UIView *)_dequeueViewOfItem:(NSObject<RNSModelProtocol> *)item{
    
    __kindof UIView *view =  [[_RNSComponentViewPool shareInstance]
                              dequeueComponentViewWithIdentifier:[item getUniqueId] viewClass:[item getComponentViewClass]];
    
    view.frame = [item getComponentFrame];
    [view setRNSId:[item getUniqueId]];
    [self.dequeueViewsDic setValue:view forKey:[item getUniqueId]];
    
    return view;
}

- (void)_enqueueViewOfItem:(NSObject<RNSModelProtocol> *)item{
    __kindof UIView *view = [self getComponentViewByItem:item];
    [view removeFromSuperview];
    [view setRNSId:@""];
    [self.dequeueViewsDic removeObjectForKey:[item getUniqueId]];
    [self.scrollViewSubViews removeObject:view];
    [[_RNSComponentViewPool shareInstance] enqueueComponentView:view];
    
}

- (__kindof UIView *)_triggerComponentEvent:(RNSComponentViewState)event withItem:(NSObject<RNSModelProtocol> *)item{

    if(!item){
        return nil;
    }

    __kindof UIView * view = [self getComponentViewByItem:item];
    
    if (_changeBlock) {
        _changeBlock(event,item,view);
    }
    
    return view;
}

#pragma mark -

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self detailComponentsDidUpdateWithOffsetTop:scrollView.contentOffset.y forceLayout:NO];
}
- (void)scrollViewDidScrollTo:(CGFloat)offsetTop {
    [self detailComponentsDidUpdateWithOffsetTop:offsetTop forceLayout:NO];
}

@end
