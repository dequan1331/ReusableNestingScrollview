//
//  NSObject + RNSComponent.h
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RNSComponentState) {
    kRNSComponentStateNone,        //准备区之外
    kRNSComponentStatePrepare,     //在准备区域
    kRNSComponentStateVisible,     //在可视区域
};

@interface NSObject (RNSComponent)
@property(nonatomic, assign, readwrite) RNSComponentState oldState;   //页面滚动复用标志位
@property(nonatomic, assign, readwrite) RNSComponentState newState;   //页面滚动复用标志位
@end
