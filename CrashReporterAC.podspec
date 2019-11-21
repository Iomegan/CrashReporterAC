Pod::Spec.new do |s|
  s.name            = "CrashReporterAC"
  s.version         = "0.1.3"
  s.summary         = "Introduces the missing Crash Dialog for Microsofts AppCenter."
  s.description     = <<-DESC
                       A bug report contains device logs, stack traces, and other diagnostic information to help you find and fix bugs in your app. It should also include user feedback that helps you to reproduce the issue. Unfortunately that's not part of Microsoft's AppCenter implementation for macOS. However there are APIs that allow you to send text attachments with each crash. CrashReporterAC asks the user for feedback and submits it with the crash details to AppCenter.
                       DESC
  s.homepage        = "https://github.com/Iomegan/CrashReporterAC"
  s.screenshots     = 'https://raw.githubusercontent.com/Iomegan/CrashReporterAC/master/Screenshot.png', 'https://raw.githubusercontent.com/Iomegan/CrashReporterAC/master/Screenshot2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { "Daniel Witt" => "info@witt-software.com" }
  s.social_media_url = 'https://twitter.com/witt_software'
  s.platform        = :osx, "10.10"
  s.osx.deployment_target = "10.10"
  s.source          = { :git => "https://github.com/Iomegan/CrashReporterAC.git", :tag => "0.1.3" }
  s.source_files    = 'Sources/*.{swift}'
  s.resources       = "Sources/*.{xib}"
  s.dependency        'AppCenter/Crashes'
  s.requires_arc    = true
  s.static_framework = true
end
