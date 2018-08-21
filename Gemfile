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

def gem_type(place_or_version)
  if place_or_version =~ %r{\Agit[:@]}
    :git
  elsif !place_or_version.nil? && place_or_version.start_with?('file:')
    :file
  else
    :gem
  end
end


if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '~> 5.5', '>= 5.5.3'
end

if rspecpuppetversion = ENV['RSPEC_PUPPET_VERSION']
  gem 'rspec-puppet', rspecpuppetversion, :require => false
else
  gem 'rspec-puppet', '2.6.15'
end

# json > v2.0 requires ruby>2.0
if RUBY_VERSION >= '1.9' and RUBY_VERSION < '2.0'
  gem 'fast_gettext', '~> 1.1.0'
  gem 'metadata-json-lint', '~> 1.1.0'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.4.2'
  gem 'puppet-lint', '~> 1.1.0'
  gem 'puppet-syntax', '~> 2.0.0'
  gem 'puppetlabs_spec_helper', '~> 1.0.0'
  gem 'json', '~> 1.8.3'
  gem 'json_pure', '~> 1.8.3'
end

if RUBY_VERSION >= '2.0' and RUBY_VERSION < '2.1'
  gem 'fast_gettext', '~> 1.1.0'
  gem 'metadata-json-lint'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
end

if RUBY_VERSION > '2.1'
  gem 'metadata-json-lint'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
end

gem 'rspec-puppet-facts'

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

gems = {}

# If facter or hiera versions have been specified via the environment
# variables
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']
gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

if Gem.win_platform? && puppet_version =~ %r{^(file:///|git://)}
  # If we're using a Puppet gem on Windows which handles its own win32-xxx gem
  # dependencies (>= 3.5.0), set the maximum versions (see PUP-6445).
  gems['win32-dir'] =      ['<= 0.5.1', require: false]
  gems['win32-eventlog'] = ['<= 0.6.7', require: false]
  gems['win32-process'] =  ['<= 0.8.3', require: false]
  gems['win32-security'] = ['<= 0.5.0', require: false]
  gems['win32-service'] =  ['1.0.1', require: false]
  gems["puppet-module-posix-default-r#{minor_version}"] =  [require: false]
  gems["puppet-module-posix-dev-r#{minor_version}"] =  [require: false]
end

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

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
