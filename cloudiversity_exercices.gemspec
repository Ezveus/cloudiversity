$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exercices/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cloudiversity_exercices"
  s.version     = Exercices::VERSION
  s.authors     = ["David `Ivad` Ivanovic"]
  s.email       = ["david.ivanovic.fr@gmail.com"]
  s.homepage    = "http://cloudiversity.eu"
  s.summary     = "Exercices module for Cloudiversity"
  s.description = <<EOF
Exercices module for Cloudiversity.
EOF

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.4"
  s.add_dependency "haml-rails"
  s.add_dependency "pundit"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"

  s.test_files = Dir["spec/**/*"]
end
