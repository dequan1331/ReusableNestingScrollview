_**This repo will no longer be updated. The new versions has been moved to [HybridPageKit](https://github.com/dequan1331/HybridPageKit) as a submodule. Integrate ' HybridPageKit/ScrollReuseHandler ' subspecs with Cocoapods.**_

***

<br>
<br>

# ReusableNestingScrollview

[Extended Reading](https://dequan1331.github.io/index-en.html) | [中文](./README_CN.md) | [扩展阅读](https://dequan1331.github.io/)

`ReusableNestingScrollview` is a component to solve the problem of SubView global reuse and recovery in rolling views. Unlike traditional similar solutions, `RNS `does not need to inherit a special ScrollView, does not need to inherit a special Model ,only by extending the Delegate, so that the rolling views such as WKWebView, UIWebView, and so on are more widely supported, more general and independent. 

> Together with [WKWebViewExtension](https://github.com/dequan1331/WKWebViewExtension), sub repo of [HybridPageKit](https://github.com/dequan1331/HybridPageKit), which is a general sulotion of news App content page.

## Requirements
iOS 8.0 or later

		
##	Installation

1.	CocoaPods
	
		platform :ios, '8.0'
		pod 'ReusableNestingScrollview'

2.	Cloning the repository

	```objective-c
	#import "RNSHandler.h"
	```


##	Features

1.	Easy integration, just need 10+ lines code.
2. 	Do not need inherit special ScrollView and special Model. Support WKWebView & UIWebView.
3.	Data-driven, Protocol Oriented Programming.
4. 	Add workrange. Better view`s state management, flexible handling of business logic.
5.	Scroll reuse & Global reuse, and Thread safe.


#Usage
		
1.	Extend View`s Model By RNSModelProtocol

```objc
@interface TestModel : NSObject <RNSModelProtocol>
	
RNSProtocolImp(_uniqueId, _componentFrame, [componentView class],[componentController class], _customContext); 

```
2.	Config ScrollView delegate

```objc
_handler = [[RNSHandler alloc]initWithScrollView:scrollView
                      externalScrollViewDelegate:self 
                        scrollWorkRange:200.f 
                        componentViewStateChangeBlock:^(RNSComponentViewState state, 
                        NSObject<RNSModelProtocol> *componentItem, __kindof UIView *componentView) {
    
    // handle component state change
    // will Prepare & will Display & end Display & end prepare
}];
```
3.	reload Data with Model

```objc
[_handler reloadComponentViewsWithProcessBlock:^(NSMutableDictionary<NSString *,NSObject<RNSModelProtocol> *> *componentItemDic) {        
	
	// update model`s origin
}];
```
## Licenses

All source code is licensed under the [MIT License](https://github.com/dequan1331/ReusableNestingScrollview/blob/master/LICENSE).

## Contact

<img src="./contact.png">
