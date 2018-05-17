//
//  _RNSComponentViewPool.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RNSComponentViewPoolMaxResuableCount 10

@interface _RNSComponentViewPool : NSObject

+ (_RNSComponentViewPool *)shareInstance;

- (__kindof UIView *)dequeueComponentViewWithIdentifier:(NSString*)identifier
                                              viewClass:(Class)viewClass;

- (void)enqueueComponentView:(__kindof UIView *)componentView;
- (void)enqueueAllComponentViewOfSuperView:(__kindof UIView *)superView;

- (void)clearAllReusableComponentViews;

#pragma mark -

- (NSDictionary *)getDequeueViewsDic;
- (NSDictionary *)getEnqueueViewsDic;

@end
