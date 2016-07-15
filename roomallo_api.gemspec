Gem::Specification.new do |s|
  s.name  = 'roomallo_api'
  s.version = RoomalloApi::VERSION
  s.date    = '2016-07-05'
  s.summary = 'Roomallo API Client - wrapper which allows to make authenticated calls to the Roomallo API'
  s.description = 'Roomallo API Client - wrapper which allows to make authenticated calls to the Roomallo API'
  s.authors  = 'Ben Hawker'
  s.email    = 'ben.c.hawker@gmail.com'
  s.files    =   Dir.glob("{lib,spec,doc}/**/*") + %w(Gemfile README.md)
  s.license  = 'MIT'

  s.add_dependency 'activemodel'
  s.add_dependency 'httparty'
end
