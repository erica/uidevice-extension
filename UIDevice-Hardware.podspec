Pod::Spec.new do |s|
  s.name         = 'UIDevice-Hardware'
  s.version      = '0.0.1'
  s.license      = 'BSD'
  s.summary      = 'Add functionality to UIDevice to distinguish between platforms like iPod touch 1G and 2G and iPhone.'
  s.homepage     = 'https://github.com/monospacecollective/UIDevice-Hardware'
  s.author       = { 'Erica Sadun' => 'erica@ericasadun.com' }
  s.source       = { :git => 'https://github.com/monospacecollective/UIDevice-Hardware.git', :tag => '0.0.1' }
  s.source_files = 'UIDevice-Hardware.{h,m}'
  s.platform     = :ios
end
