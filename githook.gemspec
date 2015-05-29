require File.expand_path('../lib/githook/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'githook'
  s.version = Githook::VERSION
  s.summary = "A Ruby DSL for defining your very own Github bot. The lingua franca for the DSL is Github webhook requests"
  s.authors = ['Michael West']
  s.files = Dir.glob("lib/**/*.rb")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency('octokit')
  s.add_dependency('rack')
end
