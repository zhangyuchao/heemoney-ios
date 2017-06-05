
Pod::Spec.new do |s|

  s.name         = "HYMergeSDK"
  s.version      = "1.0.0"
  s.summary      = "汇元聚合支付iOS SDK."
  s.homepage     = "https://github.com/zhangyuchao/heemoney-ios"
  s.license      = "MIT"
  s.authors      = { "zhangyuchao" => "zhangyuchaofight@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zhangyuchao/heemoney-ios.git", :tag => "1.0.0" }
  s.requires_arc = true

  s.default_subspec = "Core", "Wx", "Alipay"

  s.subspec 'Core' do |core|
    core.source_files  = 'SDK/HeeMoneySDK/*.h'
    core.vendored_libraries = 'SDK/HeeMoneySDK/*.a'
    core.requires_arc = true
    core.ios.library = 'c++', 'z'
    core.frameworks = 'UIKit', 'CoreGraphics', 'CoreTelephony', 'JavaScriptCore', 'SystemConfiguration', 'CFNetwork', 'CoreMotion', 'Security', 'CoreLocation'
    core.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

  s.subspec 'Wx' do |wx|
    wx.vendored_libraries = 'SDK/Channel/WXPay/libWeChatSDK.a', 'SDK/Channel/WXPay/*.a'
    wx.source_files = 'SDK/Channel/WXPay/*.h'
    wx.ios.library = 'sqlite3.0'
    wx.dependency 'HYMergeSDK/Core'
  end

  s.subspec 'Alipay' do |alipay|
    alipay.vendored_frameworks = 'SDK/Channel/AliPay/AlipaySDK.framework'
    alipay.vendored_libraries = 'SDK/Channel/AliPay/*.a'
    alipay.dependency 'HYMergeSDK/Core'
  end



end
