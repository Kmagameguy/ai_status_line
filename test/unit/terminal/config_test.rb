# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal
  class ConfigTest < ::Minitest::Test
    describe "Config" do
      describe "#color_scheme" do
        context "with a custom config file" do
          subject { Config.new(path: File.expand_path("../../fixtures/custom_config.yml", __dir__)) }

          it "shows the color scheme from the config file" do
            assert_equal "nord", subject.color_scheme
          end
        end

        context "without a custom config file" do
          before { Config.any_instance.stubs(:load_config_file).returns({}) }
          subject { Config.new }

          it "uses the default color scheme" do
            assert_equal "default", subject.color_scheme
          end
        end
      end

      describe "#lines" do
        context "with a custom config file" do
          subject { Config.new(path: File.expand_path("../../fixtures/custom_config.yml", __dir__)) }

          it "shows the lines from the config file" do
            expected = [
              %w[model working_directory],
              %w[context_used session_cost session_length]
            ]

            assert_equal expected, subject.lines
          end
        end

        context "without a custom config file" do
          before  { Config.any_instance.stubs(:load_config_file).returns({}) }
          subject { Config.new }

          it "uses the default lines configuration" do
            expected = Config.const_get(:DEFAULT_LINES)

            assert_kind_of Array, expected
            refute_empty expected
            assert_equal expected, subject.lines
          end
        end
      end
    end
  end
end
