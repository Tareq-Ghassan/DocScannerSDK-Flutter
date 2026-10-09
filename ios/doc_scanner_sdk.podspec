Pod::Spec.new do |s|
  s.name             = 'doc_scanner_sdk'
  s.version          = '1.0.0'
  s.summary          = 'Flutter wrapper — embeds DocScannerSDK-iOS source snapshot.'
  s.homepage         = 'https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Tareq Abu Saleh' => 'tareq.abusaleh47@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'doc_scanner_sdk/Sources/doc_scanner_sdk/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'
  s.swift_version = '5.9'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
