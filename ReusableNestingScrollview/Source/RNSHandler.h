//
//  RNSHandler.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNSModelProtocol.h"

typedef NS_ENUM(NSInteger, RNSComponentViewState) {
    kRNSComponentViewWillPreparedComponentView,
    kRNSComponentViewWillDisplayComponentView,
    kRNSComponentViewEndDisplayComponentView,
    kRNSComponentViewEndPreparedComponentView,
    kRNSComponentViewReLayoutPreparedAndVisibleComponentView
};

typedef void (^RNSComponentViewStateChangeBlock)(RNSComponentViewState state ,NSObject<RNSModelProtocol> *componentItem ,__kindof UIView * componentView);

typedef NSDictionary<NSString *,NSObject<RNSModelProtocol> *> * (^RNSComponentProcessItemBlock)(NSDictionary<NSString *,NSObject<RNSModelProtocol> *> * componentItemDic);


@interface RNSHandler : NSObject

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView
        externalScrollViewDelegate:(__weak NSObject <UIScrollViewDelegate>*)externalDelegate
                   scrollWorkRange:(CGFloat)scrollWorkRange
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock;

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock;

- (NSObject<RNSModelProtocol> *)getComponentItemByUniqueId:(NSString *)uniqueId;
- (__kindof UIView *)getComponentViewByItem:(NSObject<RNSModelProtocol> *)item;
- (NSArray <NSObject<RNSModelProtocol> *>*)getAllComponentItems;

@end
