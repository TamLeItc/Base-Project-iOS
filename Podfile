# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BaseProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Swinject'
  
  #api request
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'Moya/RxSwift'
  
  #rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'
  pod 'RxDataSources'
  
  #realm
  pod 'RealmSwift'
  pod 'RxRealm'
  
  #convert json object
  pod 'ObjectMapper', '~> 4.2.0'
  
  pod 'Kingfisher', '~> 6.3.1'
  
  #multi language localize support
  pod 'Localize', '~> 2.3.0'
  
  #support UI
  pod 'MKProgress', '~> 1.1.0'
  pod 'MaterialComponents/Cards', '~> 124.2.0'
  pod 'Loaf'
  
  #in app
  pod 'SwiftyStoreKit', '~> 0.16.1'
  pod 'TPInAppReceipt', '~> 3.3.0'

  #ads
  pod 'Google-Mobile-Ads-SDK'

  #Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig', '7.11.0'

  #check update version
  pod 'Siren', '~> 5.7.1'
  
  #appflyers
  pod 'AppsFlyerFramework'
  
  #adjust
  pod 'Adjust', '~> 4.33.3'
  
  pod 'FoxEventLogger'
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
          t.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
          end
      end
  end
  
  
end
