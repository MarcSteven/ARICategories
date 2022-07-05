# ARICategories

这里主要是包含了所有需要用到的iOS分类方法

# installation 




### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Coordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby

platform:ios,"12.0"
use_frameworks!
target "#yourProjectName#"do
pod 'ARICategoryKit',:git => "https://github.com/ARIEnergy/ARICategories.git"
	

end
```
And then please enter the command order as below
` pod install`
 And then close the .xcodeproj file and open workspace file.
 
 import ARICategoryKit in the place you want.
