# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MovieQuotes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieQuotes
  # add pods for desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Rosefire', :git => 'https://ada.csse.rose-hulman.edu/rosefire/ios-sdk.git'
  pod 'GoogleSignIn'
  pod 'SideMenu'
  pod 'Kingfisher', '~> 6.0'
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
        end
      end
    end
  end

end
