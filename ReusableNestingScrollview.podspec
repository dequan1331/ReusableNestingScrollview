Pod::Spec.new do |s|
  s.name         = "ReusableNestingScrollview"
  s.version      = "0.1"
  s.summary      = "An scrollView handler for UIScrollView & WKWebView and other scrollViews. Providing scrollview`s subViews reusable."
  s.homepage     = "https://github.com/dequan1331/ReusableNestingScrollview"
  s.license      = "MIT"
  s.author       = "dequanzhu"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/dequan1331/ReusableNestingScrollview.git", :tag => "0.1" }
  s.source_files = "ReusableNestingScrollview/ReusableNestingScrollview", "ReusableNestingScrollview/Source/**/*.{h,m}"
  s.frameworks = "UIKit"
end