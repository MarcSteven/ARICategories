Pod::Spec.new do |s|
  s.name             = "ARICategoryKit"
  s.version          = "0.0.4"
  s.summary          = "iOS categories tool."
  s.homepage         = "https://github.com/artsy/ARICategories"
  s.license          = 'Code is MIT, then custom font licenses.'
  s.author           = { "Marc Steven" => "zhaoxinqiang328@gmail.com" }
  s.source           = { :git => "https://github.com/MarcSteven/ARICategories.git", :tag => s.version }
  

  s.platform     = :ios, '10.0'
  s.ios.deployment_target = '10.0'


  s.source_files = 'ARICategoryKit/Source/**/*.{swift,h,m}'

  s.swift_version = '5.0'
  

  s.frameworks = 'UIKit', 'Foundation'
end