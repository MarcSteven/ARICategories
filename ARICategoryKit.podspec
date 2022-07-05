Pod::Spec.new do |s|
  s.name             = "ARICategoryKit"
  s.version          = "0.6.9"
  s.summary          = "iOS categories tool."
  s.homepage         = "https://github.com/ARIEnergy/ARICategories"
  s.license          = 'Code is MIT, then custom font licenses.'
  s.author           = { "Marc Steven" => "zhaoxinqiang328@gmail.com" }
  s.source           = { :git => "https://github.com/ARIEnergy/ARICategories.git", :tag => s.version }
  

  s.platform     = :ios, '12.0'
  s.ios.deployment_target = '12.0'


  s.source_files = 'ARICategoryKit/Source/**/*.{swift,h,m}'

  s.swift_version = '5.0'
  

  s.frameworks = 'UIKit', 'Foundation'
end

