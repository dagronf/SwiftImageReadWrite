Pod::Spec.new do |s|

s.name                       = 'SwiftImageReadWrite'
s.version                    = '1.7.0'
s.summary                    = 'A basic microframework of routines for doing basic importing/exporting of `CGImage` and `NSImage`/`UIImage` type images.'
s.homepage                   = 'https://github.com/dagronf/SwiftImageReadWrite'
s.license                    = { :type => 'MIT', :file => 'LICENSE' }
s.author                     = { 'Darren Ford' => 'dford_au-reg@yahoo.com' }
s.source                     = { :git => 'https://github.com/dagronf/SwiftImageReadWrite.git', :tag => s.version.to_s }

s.module_name                = 'SwiftImageReadWrite'

s.osx.deployment_target      = '10.11'
s.ios.deployment_target      = '11.0'
s.tvos.deployment_target     = '13.0'
s.watchos.deployment_target  = '6.0'

s.osx.framework              = 'AppKit'
s.ios.framework              = 'UIKit'
s.tvos.framework             = 'UIKit'
s.watchos.framework          = 'UIKit'

s.source_files               = 'Sources/SwiftImageReadWrite/**/*.swift'
s.swift_versions             = ['5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10']

end
