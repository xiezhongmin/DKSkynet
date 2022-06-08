#
# Be sure to run `pod lib lint DKSkynet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DKSkynet'
  s.version          = '0.0.1'
  s.summary          = 'A short description of DKSkynet.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  iOS Analytics/Debugging AIDS (Memory Usage, CPU Usage, FPS, App Launch, Time Profiler, Memory Leaks, Network, Crash, UI Tools, Sandbox browsing...).
                       DESC

  s.homepage         = 'https://github.com/xiezhongmin/DKSkynet'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'duke' => '364101515@qq.com' }
  s.source           = { :git => 'https://github.com/xiezhongmin/DKSkynet.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.resource = 'DKSkynet/Resource/*'

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |sp|
    sp.public_header_files = 'DKSkynet/Classes/Core/**/*.{h}'
    sp.source_files = 'DKSkynet/Classes/Core/**/*.{h,m}','DKSkynet/Lib/XFAssistiveTouch/**/*.{h,m}'
  end

  s.dependency 'DKKit'
  s.dependency 'DKAPMMonitor'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage'
end
