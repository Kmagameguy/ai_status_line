# frozen_string_literal: true

require "bundler"
Bundler.require(:test)

require "fileutils"
require "json"
require "minitest/autorun"
require "minitest/spec"
require "minitest/stub_const"
require "mocha/minitest"

require_relative "../lib/ai_status_line"

Bundler.setup(:default, :test)

TEST_ROOT = File.expand_path(__dir__)

# Mock RSpec-style context blocks
class ::Minitest::Test
  extend Minitest::Spec::DSL

  class << self
    alias context describe
  end
end

module AiStatusLineTestHelpers
  def fixtures_path
    File.join(File.expand_path(TEST_ROOT), "fixtures")
  end
end
