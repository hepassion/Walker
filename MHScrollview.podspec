

Pod::Spec.new do |s|
  s.name         = "MHScrollview"
  s.version      = "0.0.1"
  s.summary      = "坎坎坷坷扩扩扩."
  s.homepage     = "https://github.com/hepassion/Walker"
  s.license      = "MIT"
  s.author             = { "赵明鹤" => "hepassion@163.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/hepassion/Walker.git", :tag => s.version }
  s.source_files  = ‘MHScrollview/**/*.{h,m}’
  s.requires_arc = true
  s.dependency "SDWebImage", "~> 4.0.0"


end
