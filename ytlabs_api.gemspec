Gem::Specification.new do |s|
  s.name  = 'ytlabs_client'
  s.version = YTLabsApi::VERSION
  s.date    = '2016-07-05'
  s.summary = 'YT Labs API Ruby Client'
  s.description = 'Ruby wrapper enabling authenticated calls to the YT Labs API'
  s.authors  = 'Ben Hawker'
  s.email    = 'ben.c.hawker@gmail.com'
  s.files    =   Dir.glob("{lib,spec}/**/*") + %w(Gemfile README.md)
  s.license  = 'MIT'

  s.add_dependency 'httparty'
end

