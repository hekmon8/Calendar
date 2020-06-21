#
# Be sure to run `pod lib lint NCHCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NCHCalendar'
  s.version          = '0.0.1'
  s.summary          = 'NCHCalendar is design library pod'
  s.description      = "NCHCalendar is special calendar"
  s.homepage         = 'https://github.com/nguyenhoangit57'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hoang Nguyen' => 'hoangnguyen4005@gmail.com' }
  s.source           = { :git => 'https://github.com/hoangnguyen4005/Calendar', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'NCHCalendar/Classes/**/*'
end