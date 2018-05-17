//
//  NSObject + RNSComponent.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "NSObject + RNSComponent.h"
#import <objc/runtime.h>

@implementation NSObject (RNSComponent)

- (void)setOldState:(RNSComponentState)oldState{
    objc_setAssociatedObject(self, @"oldState", @(oldState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RNSComponentState)oldState{
    NSNumber *oldStateNum = objc_getAssociatedObject(self, @"oldState");
    RNSComponentState oldState =(RNSComponentState)oldStateNum.integerValue;
    return oldState;
}
- (void)setNewState:(RNSComponentState)newState{
    objc_setAssociatedObject(self, @"newState", @(newState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RNSComponentState)newState{
    NSNumber *newStateNum = objc_getAssociatedObject(self, @"newState");
    RNSComponentState newState =(RNSComponentState)newStateNum.integerValue;
    return newState;
}

@end
