#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bluetooth_low_energy.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bluetooth_low_energy'
  s.version          = '0.1.0'
  s.summary          = 'A bluetooth low energy plugin for flutter.'
  s.description      = <<-DESC
A bluetooth low energy plugin for flutter, which can be used to develope central role apps.
                       DESC
  s.homepage         = 'https://github.com/yanshouwang/bluetooth_low_energy'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'yanshouwang' => 'yanshouwang@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SwiftProtobuf', '~> 1.0'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
