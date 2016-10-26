Pod::Spec.new do |s|
  s.name        = "SaguaroDataModel"
  s.version     = "0.96.0"
  s.summary     = "A swift 3.0 set of data model protocols and implementations for iOS/OSX applications"
  s.homepage    = "https://github.com/darrylwest/saguaro-data-model"
  s.license     = { :type => "MIT" }
  s.authors     = { "darryl.west" => "darryl.west@raincitysoftware.com" }
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "9.0"
  s.source      = { :git => "https://github.com/darrylwest/saguaro-data-model.git", :tag => s.version }
  s.source_files = "SaguaroDataModel/*.swift"
end
