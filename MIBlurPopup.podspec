Pod::Spec.new do |s|
  s.name             = 'MIBlurPopup'
  s.version          = '0.2.0'
  s.summary          = 'MIBlurPopup lets you create amazing popups with a blurred background.'
  s.homepage         = 'https://github.com/MarioIannotta/MIBlurPopup'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mario Iannotta' => 'info@marioiannotta.com' }
  s.source           = { :git => 'https://github.com/MarioIannotta/MIBlurPopup.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'
  s.source_files = 'MIBlurPopup/*.swift'
end
