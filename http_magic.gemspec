
Gem::Specification.new do |s|
  s.name = 'http_magic'
  s.version = '0.1.2'
  s.licenses = ['MIT']
  s.summary = 'Provides a more Object Oriented interface to RESTful apis.'

  s.author = 'GradesFirst'
  s.email = 'tech@gradesfirst.com'
  s.homepage = 'https://github.com/Thoughtwright-LLC/httpmagic'

  s.files = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test}/*`.split("\n")

  s.require_paths = ['lib']

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'minitest', '~> 4.7'
  s.add_development_dependency 'webmock', '~> 1.16'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'pry-debugger', '~> 0'
end
