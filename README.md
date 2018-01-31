# iPaynow-wxpay-iOS:微信独立包
## 版本要求
iOS SDK要求iOS6.0及以上

## 接入方法

### 自动接入(CocoaPod方式)
####1.添加Podfile文件
```
pod ‘ipaynowWxOnly’,'~> 2.0.2'
```
####2.运行 `pod install`
####3.使用 `.xcworkspace`打开工程
####4.设置URL Scheme

####5.注意事项
微信独立包在支付完成之后无法自动回调到原App中，需要手动返回或者使用系统自带的返回按钮。

### 手动接入
#### 1.SDK文件引用
将下列文件导入project中。

```
IpaynowPluginApi.h
IpaynowPluginDelegate.h
IPNPreSignMessageUtil.h
libipaynowPlugin.a
```
#### 2.工程设置
* 在工程中`TARGETS`-`Build Settings`-`Other Linker Flags`添加`-ObjC`.
* 将工程中`TARGETS`-`Build Settings`-`Build Options`-`Enable Bitcode`选项设置为`NO`.
* 将工程中`TARGETS`-`Build Settings`-`Build Activity Architecture Only`选项设置为`NO`.

#### 3.发起支付
详见`接入文档`。

