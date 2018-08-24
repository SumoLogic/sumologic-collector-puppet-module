source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  if place_or_version =~ %r{\A(git[:@][^#]*)#(.*)}
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  elsif place_or_version =~ %r{\Afile:\/\/(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place_or_version, { require: false }]
  end
end


group :test do
  gem "rake"
  gem "rspec"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'puppet-lint'
  gem 'puppet-syntax'
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do

  if RUBY_VERSION < '2.2.5'
    gem "beaker-rspec", '<= 5.6.0'
  else
    gem "beaker-rspec"
  end

  gem "beaker"
  gem 'beaker-vagrant'
  gem 'vagrant-wrapper'
  gem 'beaker-puppet'
  gem 'beaker-puppet_install_helper'
  gem 'beaker-module_install_helper'
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, :require => false, :groups => [:test]
else
  gem 'facter', :require => false, :groups => [:test]
end

if hieraversion = ENV['HIERA_GEM_VERSION']
  gem 'hiera', hieraversion.to_s, :require => false, :groups => [:test]
else
  gem 'hiera', :require => false, :groups => [:test]
end

if rspecpuppetversion = ENV['RSPEC_PUPPET_VERSION']
  gem 'rspec-puppet', rspecpuppetversion, :require => false
else
  gem 'rspec-puppet', '2.6.15'
end

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 5.5' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]


# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
    "#{__FILE__}.local",
    File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end
# vim: syntax=ruby
