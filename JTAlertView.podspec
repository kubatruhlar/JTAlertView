Pod::Spec.new do |s|
  s.name         = "JTAlertView"
  s.version      = "1.0.2"
  s.summary      = "JTAlertView is the new **wonderful dialog/HUD/alert** kind of View."

  s.description  = <<-DESC
                   **JTAlertView** is the new **wonderful dialog/HUD/alert** kind of View. It was also designed to cover user’s needs during **customization**. Created with **delightful combination** of image, parallax and pop effects, **JTAlertView** improves your user experience.
                   DESC

  s.homepage     = "https://github.com/kubatru/JTAlertView"
  s.screenshots  = "https://raw.githubusercontent.com/kubatru/JTAlertView/master/Screens/alertView.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/kubatru/JTAlertView.git", :tag => "1.0.2" }
  s.source_files  = "JTAlertView/*"
  s.framework  = "UIKit"
  s.requires_arc = true
end
