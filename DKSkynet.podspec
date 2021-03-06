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

  s.default_subspecs = 'Core', 'DefaultPlugins'

  s.subspec 'Core' do |sp|
      sp.public_header_files = 'DKSkynet/Classes/Core/**/*.{h}'
      sp.source_files = 'DKSkynet/Classes/Core/**/*.{h,m}','DKSkynet/Classes/Core/Lib/XFAssistiveTouch/**/*.{h,m}'
      sp.dependency 'DKSkynet/Store'
      sp.dependency 'DKSkynet/Common'
  end
  
  s.subspec 'Common' do |com|
      com.public_header_files = 'DKSkynet/Classes/Common/**/*.{h}'
      com.source_files = 'DKSkynet/Classes/Common/**/*.{h,m}'
  end
  
  s.subspec 'Store' do |sp|
      sp.public_header_files = 'DKSkynet/Classes/Store/*.{h}'
      sp.source_files = 'DKSkynet/Classes/Store/*.{h,m}'
      
      sp.subspec 'MTAppenderFile' do |mt|
          mt.public_header_files = 'DKSkynet/Classes/Store/MTAppenderFile/loglib/MTAppenderFile.h',
          'DKSkynet/Classes/Store/MTAppenderFile/loglib/mtaf_base.h',
          'DKSkynet/Classes/Store/MTAppenderFile/loglib/mtaf_appender.h'
          mt.source_files = 'DKSkynet/Classes/Store/MTAppenderFile/comm/*.{h,hpp,m,mm,cpp,cc,c}',
          'DKSkynet/Classes/Store/MTAppenderFile/loglib/*.{h,hpp,m,mm,cpp,cc,c}'
          mt.requires_arc = false
          mt.libraries = "z", "c++"
          mt.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lc++' }
      end
  end
  
  s.subspec 'DefaultPlugins' do |sp|
    sp.dependency 'DKSkynet/NetworkPlugins'
    sp.dependency 'DKSkynet/DatasInfoPlugins'
  end
  
  s.subspec 'NetworkPlugins' do |net|
      net.subspec 'Common' do |com|
          com.public_header_files = 'DKSkynet/Classes/NetworkPlugins/Common/**/*.{h}'
          com.source_files = 'DKSkynet/Classes/NetworkPlugins/Common/**/*.{h,m}'
      end
      
      net.subspec 'Monitor' do |mon|
          mon.public_header_files = 'DKSkynet/Classes/NetworkPlugins/Monitor/**/*.{h}'
          mon.source_files = 'DKSkynet/Classes/NetworkPlugins/Monitor/**/*.{h,m}'
      end
  end
  
  s.subspec 'DatasInfoPlugins' do |dat|
      dat.subspec 'Common' do |com|
          dat.public_header_files = 'DKSkynet/Classes/DatasInfoPlugins/Common/**/*.{h}'
          dat.source_files = 'DKSkynet/Classes/DatasInfoPlugins/Common/**/*.{h,m}'
      end
      
      dat.subspec 'SanboxBrowse' do |box|
          box.public_header_files = 'DKSkynet/Classes/DatasInfoPlugins/SanboxBrowse/**/*.{h}'
          box.source_files = 'DKSkynet/Classes/DatasInfoPlugins/SanboxBrowse/**/*.{h,m}'
#          box.resource = 'DKSkynet/Classes/DatasInfoPlugins/SanboxBrowse/Resources/**/*'
          box.resource_bundle = {
              'DKSanbox' => 'DKSkynet/Classes/DatasInfoPlugins/SanboxBrowse/Resources/**/*'
          }
      end
  end

  s.dependency 'DKKit'
  s.dependency 'DKAPMMonitor'
  s.dependency 'SDWebImage'
end
