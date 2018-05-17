//
//  _RNSDealgateDispatcher.h
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface _RNSDealgateDispatcher : NSObject<UIScrollViewDelegate>

//default internalDelegate is main delegate

- (instancetype)initWithInternalDelegate:(__weak NSObject <UIScrollViewDelegate>*)internalDelegate
                        externalDelegate:(__weak NSObject <UIScrollViewDelegate>*)externalDelegate;

@end
