$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "zomeki_auto_test/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "zomeki_auto_test"
  s.version     = ZomekiAutoTest::VERSION
  s.authors     = ["shimizu000"]
  s.email       = ["shimizu@sitebridge.co.jp"]
  s.homepage    = "https://github.com/shimizu000/zomeki_auto_test"
  s.summary     = "Summary of ZomekiAutoTest."
  s.description = "Description of ZomekiAutoTest."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rspec-rails"
  s.add_dependency 'capybara'
  s.add_dependency 'turnip'
  s.add_dependency 'capybara-webkit'
  s.add_dependency 'poltergeist'
  s.add_dependency 'phantomjs'
  s.add_dependency 'delayed_job_active_record'

  s.add_development_dependency "rails", "~> 5.1.3", ">= 5.0.0.1"
  s.add_development_dependency "sqlite3"
end
