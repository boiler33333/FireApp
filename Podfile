platform :ios, '14.0'

target 'FireApp' do
  use_frameworks!

  pod 'Firebase', '7.2-M1'
  pod 'Firebase/Firestore', '~> 7.2-M1'
  pod 'FirebaseFirestoreSwift', '7.2-beta'
  pod 'FirebaseStorage', '~> 7.2.0-M1'
  pod 'Firebase/Auth', '~> 7.2.0-M1'
  pod 'Firebase/Crashlytics', '~> 7.2-M1'
  pod 'Firebase/Analytics', '~> 7.2-M1'
  pod 'Firebase/Database'

  target 'FireAppTests' do
    inherit! :search_paths
  end

  target 'FireAppUITests' do
    inherit! :search_paths
  end
end
