#
#  Be sure to run `pod spec lint MoyaPlusHandyJSON.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "MoyaPlusHandyJSON"
  s.version      = "1.0"
  s.summary      = "MoyaPlusHandyJSON Extension"
  s.description  = <<-DESC
  Moya + HandyJSON + Lazy Provider
                   DESC
  s.homepage     = "https://github.com/winddpan/MoyaPlusHandyJSON"
  s.ios.deployment_target = '8.0'

  s.license      = "MIT"
  s.author       = { "winddpan" => "winddpan@126.com" }
  s.source       = { :git => "https://github.com/winddpan/MoyaPlusHandyJSON.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  
  s.dependency "Moya/RxSwift", '~> 11.0'
  s.dependency "HandyJSON", '~> 4.1.0'

end
