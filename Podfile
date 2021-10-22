# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iOSEngineerCodeCheck' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iOSEngineerCodeCheck
  pod 'R.swift' , '~> 5.4.0'
  pod 'Alamofire' , '~> 4.9.1'

  target 'iOSEngineerCodeCheckTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iOSEngineerCodeCheckUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
