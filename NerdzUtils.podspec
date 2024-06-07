

Pod::Spec.new do |s|
  s.name             = 'NerdzUtils'
  s.version          = '1.0.91'
  s.summary          = 'NERDZ LAB utilities'
  s.homepage         = 'https://github.com/nerdzlab/NerdzUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NerdzLab' => 'supernerd@nerdzlab.com' }
  s.source           = { :git => 'https://github.com/nerdzlab/NerdzUtils.git', :tag => s.version }
  s.social_media_url = 'https://nerdzlab.com'
  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.0']
  s.source_files = 'Sources/**/*'
  
  s.dependency 'KeychainAccess', '~> 4.2.0'
end
