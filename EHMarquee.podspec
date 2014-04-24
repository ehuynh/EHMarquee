Pod::Spec.new do |s|
  s.name             = "EHMarquee"
  s.version          = "0.0.0"
  s.summary          = "EHMarquee helps create an automatic scrolling view for content that is larger than its container."
  s.homepage         = "https://github.com/ehuynh/EHMarquee"
  s.license          = 'MIT'
  s.author           = { "Edward Huynh" => "edward@edwardhuynh.com" }
  s.source           = { :git => "https://github.com/ehuynh/EHMarquee.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/edwardhuynh'
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'EHMarquee/Classes/**/*.{h,m}'
end
