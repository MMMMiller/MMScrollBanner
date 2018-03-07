Pod::Spec.new do |s|
  s.name         = 'MMScrollBanner'
  s.summary      = 'A ScrollBanner for iOS.'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'MMMille' => 'xuemingluan@gmail.com' }
  #s.social_media_url = 'http://blog.MMMille.com'
  s.homepage     = 'https://github.com/MMMille/MMScrollBanner'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/MMMille/MMScrollBanner.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'MMScrollBanner/**/*.{h,m}'

  s.libraries = 'z', 'sqlite3'
  s.frameworks = 'UIKit', 'CoreFoundation'
  s.dependency 'YYKit'
  s.dependency 'MMWeakTimer'
end
#pod trunk push MMScrollBanner.podspec --allow-warnings