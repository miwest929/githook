require File.expand_path('../lib/githook/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'githook'
  s.version = Githook::VERSION
  s.summary = "A Ruby DSL for handling Github webhook requests"
  s.authors = ['Michael West']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency('octokit')
end
