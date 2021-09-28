# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in kitchen.gemspec
gemspec

gem 'rake', '~> 12.0'
gem 'rspec', '~> 3.0'

gem 'codecov', require: false

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Create unnumberedfigurespreface files
gem 'unnumberedfigurespreface', github: 'openstax/kitchen', ref: 'e907691ad25a7cb956c851acb60f23227a5a7004'
