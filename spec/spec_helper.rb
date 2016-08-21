require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.before :each do
    # Change autosign from being posix path, which breaks Puppet when we're pretending to be on Windows
    Puppet[:autosign] = true

    # Work even if you don't specify facts
    f = self.respond_to?(:facts) ? facts : {}
    # Automatically detect whether we're pretending to run on Windows
    Thread.current[:windows?] = lambda { f[:kernel] == "windows" }
  end
end

module Puppet
  module Util
    module Platform
      def self.windows?
        # This is where Puppet normally looks for the target OS.
        # It normally returns the *current* OS (i.e., not Windows,
        # if you're not running the specs on Windows)
        if Thread.current[:windows?]
          !!Thread.current[:windows?].call
        else
          false
        end
      end
    end
  end
end
