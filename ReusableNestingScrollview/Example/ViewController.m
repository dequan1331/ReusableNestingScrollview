//
//  ViewController.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "ViewController.h"
#import "RNSHandler.h"
#import <objc/runtime.h>
#import "_RNSComponentViewPool.h"
#import "RNSModelProtocol.h"

@interface TestModel : NSObject <RNSModelProtocol>
@property(nonatomic, copy, readwrite) NSString *uniqueId;
@property(nonatomic, assign, readwrite) CGRect componentFrame;
@property(nonatomic, assign, readwrite) Class componentViewClass;

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                  componentFrame:(CGRect)componentFrame
              componentViewClass:(Class)componentViewClass;
@end
@implementation TestModel
- (instancetype)initWithUniqueId:(NSString *)uniqueId
                  componentFrame:(CGRect)componentFrame
              componentViewClass:(Class)componentViewClass{
    self = [super init];
    if (self) {
        if(!uniqueId || uniqueId.length <= 0 || CGRectIsNull(componentFrame)){
            NSAssert(NO, @"RNSModel init with invalid paras");
            return nil;
        }
        
        _uniqueId = uniqueId;
        _componentViewClass = componentViewClass;
        _componentFrame = componentFrame;
    }
    return self;
}
#pragma mark - RNSModelProtocol
-(NSString *)getUniqueId{
    return _uniqueId;
}
-(void)setComponentFrame:(CGRect)frame{
    _componentFrame = frame;
}
-(CGRect)getComponentFrame{
    return _componentFrame;
}
-(Class)getComponentViewClass{
    return _componentViewClass;
}
@end


@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,readwrite,strong) UIScrollView *containerView;
@property(nonatomic,readwrite,strong) RNSHandler *handler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        self.containerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.containerView.backgroundColor = [UIColor colorWithRed:238.f/255.f green:239.f/255.f blue:240.f/255.f alpha:1.f];
        self.containerView.scrollEnabled = YES;
        self.containerView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 10);
        self.containerView;
    })];
    
    [self configRNS];
}

-(void)configRNS{
    
    __weak typeof(self) wself = self;
    _handler = [[RNSHandler alloc]initWithScrollView:self.containerView externalScrollViewDelegate:self scrollWorkRange:200 componentViewStateChangeBlock:^(RNSComponentViewState state, NSObject<RNSModelProtocol> *componentItem, __kindof UIView *componentView) {
        
        if (state == kRNSComponentViewWillPreparedComponentView) {
            
            NSDictionary *dequeueViews = [[_RNSComponentViewPool shareInstance] getDequeueViewsDic];
            NSDictionary *enqueueViews = [[_RNSComponentViewPool shareInstance] getEnqueueViewsDic];
            
            NSMutableString *logStr = @"".mutableCopy;
            
            for (NSString *classStr in dequeueViews.allKeys) {
                NSSet *viewSet = [dequeueViews objectForKey:classStr];
                [logStr appendFormat:@"\n dequeueViews------class:%@ -- count:%@",classStr,@(viewSet.count)];
            }
            
            for (NSString *classStr in enqueueViews.allKeys) {
                NSSet *viewSet = [enqueueViews objectForKey:classStr];
                [logStr appendFormat:@"\n enqueueViews-------class:%@ -- count:%@",classStr,@(viewSet.count)];
            }
            
            NSLog(@"%@",logStr);
        }
        
        if (state == kRNSComponentViewWillDisplayComponentView) {
            
            if([componentView isKindOfClass:[UIImageView class]]){
                [((UIImageView *)componentView) setImage:[UIImage imageNamed:@"image.jpg"]];
                //[((UIImageView *)componentView) setContentMode:UIViewContentModeScaleToFill];
            }else if ([componentView isKindOfClass:[UILabel class]]){
                [((UILabel *)componentView) setBackgroundColor:[UIColor colorWithRed:28.f/255.f green:135.f/255.f blue:219.f/255.f alpha:1.f]];
                [((UILabel *)componentView) setText:@"HybridPageKit"];
                [((UILabel *)componentView) setTextColor:[UIColor whiteColor]];
                [((UILabel *)componentView) setTextAlignment:NSTextAlignmentCenter];
            }
            
            NSLog(@"ViewController will display index:%@",[componentItem getUniqueId]);
        }
        
        if (state == kRNSComponentViewEndDisplayComponentView) {
            NSLog(@"ViewController will display index:%@",[componentItem getUniqueId]);
        }
    }];
    
    [_handler reloadComponentViewsWithProcessBlock:^NSDictionary<NSString *,NSObject<RNSModelProtocol> *> *(NSDictionary<NSString *,NSObject<RNSModelProtocol> *> *componentItemDic) {
        CGFloat offsetY = 0.f;
        NSArray * viewClassArray = @[@"UIImageView",@"UILabel"];
        NSMutableDictionary *componentItemDicTmp = componentItemDic.mutableCopy;
        
        for (int i = 0 ;i < 20; i++) {
            CGFloat height = (arc4random_uniform(3) + 1) * 50;
            [componentItemDicTmp setObject:[[TestModel alloc]initWithUniqueId:@(i).stringValue
                                                            componentFrame:CGRectMake(0, offsetY, [[UIScreen mainScreen] bounds].size.width, height)
                                                        componentViewClass:NSClassFromString([viewClassArray objectAtIndex:arc4random_uniform(2)])] forKey:@(i).stringValue];
            offsetY += height + 20;
        }
        
        wself.containerView.contentSize = CGSizeMake(self.containerView.contentSize.width, offsetY);
        return [componentItemDicTmp copy];
    }];
}

#pragma mark

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"ViewController scrollview did scroll");
}

@end
