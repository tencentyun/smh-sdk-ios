
Pod::Spec.new do |s|
  s.name             = "QCloudCOSSMH"
s.version              = "1.0.1"
  s.summary          = "QCloudCOSSMH 腾讯云iOS-SDK组件"

  s.homepage         = "https://cloud.tencent.com/"
  s.license          = 'MIT'
  s.author           = { "QCloud Terminal Team" => "QCloudTerminalTeam" }
  s.source           = { :git => "https://github.com/tencentyun/smh-sdk-ios.git", :tag => s.version.to_s }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.12"

  s.static_framework = true
  
  s.default_subspec = 'Default'
  s.subspec 'Default' do |default|
    default.source_files = 'QCloudCOSSMH/Classes/**/*'
    default.exclude_files = 'QCloudCOSSMH/Classes/Api/QCloudCOSSMHApi.h','QCloudCOSSMH/Classes/User/QCloudCOSSMHUser.h'
    default.dependency "QCloudCore",'6.3.7'
  end
  
  s.subspec 'WithoutCoreVersion' do |withoutCoreVersion|
    withoutCoreVersion.source_files = 'QCloudCOSSMH/Classes/**/*'
    withoutCoreVersion.exclude_files = 'QCloudCOSSMH/Classes/Api/QCloudCOSSMHApi.h','QCloudCOSSMH/Classes/User/QCloudCOSSMHUser.h'
    withoutCoreVersion.dependency "QCloudCore"
  end
  
  s.subspec 'Slim' do |slim|
    slim.source_files = 'QCloudCOSSMH/Classes/**/*'
    slim.exclude_files = 'QCloudCOSSMH/Classes/Api/QCloudCOSSMHApi.h','QCloudCOSSMH/Classes/User/QCloudCOSSMHUser.h'
    slim.dependency "QCloudCore/WithoutMTA",'6.3.7'
  end

  s.subspec 'Api' do |api|
    api.source_files = 'QCloudCOSSMH/Classes/Api/*',
                       'QCloudCOSSMH/Classes/Api/**/*',
                       'QCloudCOSSMH/Classes/QCloudCOSSMHVersion.*',
                       'QCloudCOSSMH/Classes/Common/*',
                       'QCloudCOSSMH/Classes/Common/**/*'
    api.dependency "QCloudCore/WithoutMTA",'6.3.7'
  end

end
