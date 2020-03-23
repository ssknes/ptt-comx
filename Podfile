# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Trading Mobile' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  project 'Trading Mobile.xcodeproj'
  use_frameworks!

  # Pods for topcpai
    pod 'MBProgressHUD'
    pod 'Kingfisher'
    pod 'XCGLogger'
    pod 'Alamofire'
    pod 'Firebase'
    pod 'Firebase/Messaging'
    pod 'AEXML'
    pod 'SwiftKeychainWrapper'
    pod 'ReachabilitySwift'
    pod 'CryptoSwift','~> 0.7.2' #, :git => "https://github.com/krzyzanowskim/CryptoSwift", :branch => "master"  # swift 4
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SideMenu'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end

#target 'Trading MobileTests' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
#  use_frameworks!

  # Pods for topcpai
#    pod 'MBProgressHUD'
#   pod 'Kingfisher'
#   pod 'XCGLogger'
#   pod 'Alamofire'
#   pod 'Firebase'
#   pod 'Firebase/Messaging'
#   pod 'AEXML'
#   pod 'SwiftKeychainWrapper'
#   pod 'ReachabilitySwift'
#   pod 'CryptoSwift', :git => "https://github.com/krzyzanowskim/CryptoSwift", :branch => "master" # swift 4

#end
