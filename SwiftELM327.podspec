#
#  Be sure to run `pod spec lint SwiftELM327.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SwiftELM327"
  s.version      = "0.0.1"
  s.summary      = "SwiftELM327."

  s.homepage     = "https://github.com/orungrau/SwiftELM327"

  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

  s.author             = { "Anatoly Myaskov" => "myaskov@me.com" }
  # Or just: s.author    = "Anatoly Darkos"
  # s.authors            = { "Anatoly Darkos" => "myaskov@me.com" }
  # s.social_media_url   = "http://twitter.com/Anatoly Darkos"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/orungrau/SwiftELM327.git", :tag => s.version }

  s.source_files  = "Source", "Source/*.swift"
end
