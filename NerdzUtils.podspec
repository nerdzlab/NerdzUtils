
Pod::Spec.new do |s|
  s.name             = 'NerdzUtils'
  s.version          = '1.0.21'
  s.summary          = 'A list of small twiks to make it easy coding'
  s.homepage         = 'https://github.com/nerdzlab/NerdzUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NerdzLab' => 'supernerd@nerdzlab.com' }
  s.source           = { :git => 'https://github.com/nerdzlab/NerdzUtils.git', :tag => s.version }
  s.dependency 'KeychainAccess'
  s.social_media_url = 'https://nerdzlab.com'
  s.ios.deployment_target = '8.0'
  s.swift_versions = ['5.0']
  s.source_files = 'Sources/**/*'
end
