#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "CXFocusView"
  s.version                 = "0.0.1"
  s.summary                 = "Basic UIView overlay (for tutorials etc.)"
  s.homepage                = "https://github.com/dclelland/CXFocusView"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/CXFocusView.git", :tag => "0.0.1" }
  s.platform                = :ios, '7.0'
  s.ios.deployment_target   = '7.0'
  s.ios.source_files        = 'CXFocusView/*.{h,m}'
  s.requires_arc            = true

  s.dependency 'Masonry'
  s.dependency 'ObjectiveSugar'
end