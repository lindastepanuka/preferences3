$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "preferences3/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "preferences3"
  s.version     = Preferences3::VERSION
  s.authors     = ["Kristaps Erglis"]
  s.email       = ["kristaps.erglis@gmail.com"]
  s.homepage    = "https://github.com/kerglis/preferences3"
  s.summary     = "Adds support for easily creating custom preferences for ActiveRecord models"
  s.description = "Adds support for easily creating custom preferences for ActiveRecord models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 5.0'

  s.add_development_dependency("rake")

end
