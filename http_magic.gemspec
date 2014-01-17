
Gem::Specification.new do |s|
  s.name        = 'http_magic'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Provides a more Object Oriented interface to RESTful apis.'
  s.description = 'Provides a more Object Oriented interface to RESTful apis.'
  s.authors     = ['Anthony Crumley', 'Matthew Turney']
  s.files       = ['lib/http_magic.rb']
  s.homepage    = 'https://github.com/Thoughtwright-LLC/httpmagic'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '~> 4.7.0'
  s.add_development_dependency 'webmock', '~> 1.16.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-debugger'
end
