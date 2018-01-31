Pod::Spec.new do |s|

  
  s.name         = "ipaynowWxOnly"
  s.version      = "2.0.1"
  s.summary      = "ipaynowplugin SDK"
  s.description  = <<-DESC
                   Help developer to quickly intergrate WechatPay
                   DESC
  s.homepage     = "http://www.ipaynow.cn"
  s.license      = "MIT"
  s.author       = { "Chuck" => "lipengchang@ipaynow.cn" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/iPaynow/iPaynow-wxpay-iOS.git", :tag => s.version }
  s.default_subspec = 'Core'
  s.requires_arc = true
  
  s.subspec 'Core' do |core|
    core.source_files = "SDK/*.h"
    core.public_header_files = "SDK/*.h"
    core.vendored_libraries = "SDK/iphone+simulator/*.a"
    core.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

end