Pod::Spec.new do |spec|
  spec.name             = 'MIBlurPopup'
  spec.version          = '0.1.0'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/MarioIannotta/MIBlurPopup'
  spec.authors          = { 'Mario Iannotta' => 'info@marioiannotta.com' }
  spec.summary          = 'A simple fully customizable alert controller'
  spec.source           = { :git => 'https://github.com/MarioIannotta/MIBlurPopup.git', :tag => spec.version.to_s }
  spec.source_files     = 'MIBlurPopup/*'
  spec.ios.deployment_target = '8.0'
end
