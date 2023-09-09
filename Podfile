target 'PACReceipts' do

  use_frameworks!

  # Pods for PACReceipts
pod "Pastel"
pod "Haptica"
pod 'Alertift', '~> 4.2'

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
               end
          end
   end
end
end