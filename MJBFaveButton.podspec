#
# Be sure to run `pod lib lint MJBFaveButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJBFaveButton'
  s.version          = '0.3.1'
  s.summary          = 'Favorite Animated Button written in Swift, based on xhamr/fave-button.'
  s.description      = <<-DESC
                      This is a very easy to use animated button based on xhamr/fave-button, which can achieve a cool praise effect like Twitter. The original framework can not support the normal/selected image as a normal UIButton, so I made some changes to support this feature.
                       DESC
  s.homepage         = 'https://github.com/Hackice/MJBFaveButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hackice' => 'hackice@sina.cn' }
  s.source           = { :git => 'https://github.com/Hackice/MJBFaveButton.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.source_files = 'MJBFaveButton/Classes/**/*'
  
end
