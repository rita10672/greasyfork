ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def get_valid_script
	script = Script.new
	script_version = ScriptVersion.new
	script.script_versions << script_version
	script_version.script = script

	script_version.code = <<END
// ==UserScript==
// @name		A Test!
// @description		Unit test.
// ==/UserScript==
var foo = "bar";
END
	script.apply_from_script_version(script_version)
	script.user = User.find(1)
	assert (script.valid? and script_version.valid?), (script.errors.full_messages + script_version.errors.full_messages).inspect
	return script
  end
end
