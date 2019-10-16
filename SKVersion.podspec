#
# Be sure to run `pod lib lint SplitViewTest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SKVersion'
  s.version          = '2.0.0'
  s.summary          = 'Version Update Checker'
  s.swift_versions   = ['5.0']

  s.description      = <<-DESC
App Store Version update checker
                       DESC

  s.homepage         = 'https://github.com/twodayslate/SKVersion'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'twodayslate' => 'zac@gorak.us' }
  s.source           = { :git => 'https://github.com/twodayslate/SKVersion.git', :tag => "v#{s.version}" }
  s.social_media_url = 'https://twitter.com/twodayslate'

  s.ios.deployment_target = '11.0'

  s.source_files = 'SKVersion/*'
  s.exclude_files = [ 'SKVersion/Info.plist']

  s.public_header_files = 'SKVersion/*.h'
  s.dependency 'Version', '~> 0.7.0'
end
