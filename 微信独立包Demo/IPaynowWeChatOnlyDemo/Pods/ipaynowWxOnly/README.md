# iPaynow-wxpay-iOS:微信独立包
## 版本要求
iOS SDK要求iOS6.0及以上

## 接入方法
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

