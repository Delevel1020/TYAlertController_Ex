Pod::Spec.new do |spec|
  spec.name         = "TYAlertController_Ex"
  spec.version      = "0.1.0"
  spec.summary      = "TYAlertController_Ex is Modify the library based on the third-party TYAlertController"
  spec.homepage     = "https://github.com/Delevel1020/TYAlertController_Ex.git"
  spec.license      = "MIT"
  spec.author       = { "delevel" => "delevel1020@gmail.com" }
  spec.ios.deployment_target = "10.0"
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/Delevel1020/TYAlertController_Ex.git", :tag => spec.version }
  spec.requires_arc = true
  spec.static_framework = true
  spec.source_files  = "TYAlertController_Ex/TYAlertController_Ex/*.{h,m}"
end
