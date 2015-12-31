#  Be sure to run `pod spec lint Marklight.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |s|
  s.name                  = "Marklight"
  s.version               = "0.1.0"
  s.summary               = "Markdown syntax highlighter for iOS."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description           = <<-DESC
                            DESC
  s.homepage              = "https://github.com/macteo/Marklight"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Matteo Gavagnin" => "m@macteo.it" }
  s.social_media_url      = "http://twitter.com/macteo"
  s.platform              = :ios
  s.ios.deployment_target = "8.0"
  s.source                = { :git => "https://github.com/macteo/Marklight.git", :tag => "v0.1.0" }
  s.source_files          = "Marklight/**/*.{swift}"
  s.requires_arc          = true
end
