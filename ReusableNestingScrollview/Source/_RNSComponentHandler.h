//
//  _RNSComponentHandler.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNSHandler.h"
#import "RNSModelProtocol.h"

@interface _RNSComponentHandler : NSObject<UIScrollViewDelegate>

@property(nonatomic, assign, readwrite) CGFloat componentWorkRange;

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView
     componentViewStateChangeBlock:(RNSComponentViewStateChangeBlock)componentViewStateChangeBlock;

- (void)reloadComponentViewsWithProcessBlock:(RNSComponentProcessItemBlock)processBlock;

#pragma mark -

- (NSObject<RNSModelProtocol> *)getComponentItemByUniqueId:(NSString *)uniqueId;
- (__kindof UIView *)getComponentViewByItem:(NSObject<RNSModelProtocol> *)item;

- (NSArray <NSObject<RNSModelProtocol> *>*)getAllComponentItemsWithorderByOffset:(BOOL)orderByOffset;
- (NSArray <NSObject<RNSModelProtocol> *>*)getVisiableComponentItems;        //返回visible的ComponentItem
- (NSArray <NSObject<RNSModelProtocol> *>*)getPreparedComponentItems;        //返回prepared的ComponentItem

@end
