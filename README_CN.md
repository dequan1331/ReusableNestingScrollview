_**暂停更新. 相关功能作为Submodule调整到 [HybridPageKit](https://github.com/dequan1331/HybridPageKit) 项目中. 后续使用Cocoapods，集成HybridPageKit的subspecs ——'HybridPageKit/ScrollReuseHandler'**_

***

<br>
<br>

#	ReusableNestingScrollview

[英文](./README.md) | [扩展阅读](https://dequan1331.github.io/) | [Extended Reading](https://dequan1331.github.io/index-en.html)

`ReusableNestingScrollview`是一个解决滚动视图中SubView全局复用和回收问题的组件。区别于传统的类似解决方案，`RNS`无需继承特殊ScrollView，无需继承特殊Model，只通过扩展Delegate的方式实现，从而更广泛的支持WKWebView、UIWebView等滚动视图，更加通用和独立。

> 与[WKWebViewExtension](https://github.com/dequan1331/WKWebViewExtension)一起，组件服务于[HybridPageKit](https://github.com/dequan1331/HybridPageKit)，一个资讯类内容底层页完整的通用组件。

## 配置

iOS 8.0 or later

		
##	安装

1.	CocoaPods
	
		platform :ios, '8.0'
		pod 'ReusableNestingScrollview'

2.	下载repo并引入头文件

	```objective-c
	#import "RNSHandler.h"
	```


##	特点

1.	实现简单，10行代码即可完成
2.	无需继承特殊ScrollView，无需继承特殊Model，适用于WebView等全部滚动视图
3.	数据驱动，面向协议易于扩展
4.	增加workRange，更加完善的区域和状态，灵活处理业务逻辑
5.	滚动复用、全局复用、线程安全
	

#使用
	
**只需三步，轻松实现**
	
1.	扩展view相关联数据Model实现protocol

```objc
@interface TestModel : NSObject <RNSModelProtocol>
	
RNSProtocolImp(_uniqueId, _componentFrame, [componentView class],[componentController class], _customContext); 
```
2.	扩展ScrollView delegate

```objc
_handler = [[RNSHandler alloc]initWithScrollView:scrollView
                      externalScrollViewDelegate:self 
                        scrollWorkRange:200.f 
                        componentViewStateChangeBlock:^(RNSComponentViewState state, 
                        NSObject<RNSModelProtocol> *componentItem, __kindof UIView *componentView) {
    
    // 复用回收View状态变化处理
    // 进入准备区 & 进入展示 & 离开展示 & 离开准备区
}];
```
3.	增加、修改数据时reload

```objc
[_handler reloadComponentViewsWithProcessBlock:^(NSMutableDictionary<NSString *,NSObject<RNSModelProtocol> *> *componentItemDic) {        
	
	//修改、重新设置componentItemDic中model的origin
}];
```

## 证书

All source code is licensed under the [MIT License](https://github.com/dequan1331/ReusableNestingScrollview/blob/master/LICENSE).