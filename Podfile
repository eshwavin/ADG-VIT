# Uncomment the next line to define a global platform for your project
# platform :ios, ’9.0’

target 'ADG VIT' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ADG VIT
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'RealmSwift'

  target 'ADG VITTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ADG VITUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
