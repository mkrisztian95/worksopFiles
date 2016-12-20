Pod::Spec.new do |s|
s.name             = 'CPBanners'
s.version          = '0.1.0'
s.summary          = 'By far the most fantastic Pod I have seen in my entire life. No joke.'

s.description      = <<-DESC
This fantastic Pod changes its color gradually makes your app look fantastic!
DESC

s.homepage         = 'https://github.com/mkrisztian95/CPBanner'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Molnar Kristian' => 'mkrisztian95@gmail.com' }
s.source           = { :git => 'https://github.com/mkrisztian95/CPBanner.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'CocoaPodExample/CPBanner.swift'

end
