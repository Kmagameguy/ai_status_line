# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::ColorSchemes
  class ColorSchemeTest < ::Minitest::Test
    describe "ColorScheme" do
      before { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }
      describe "REGISTRY" do
        subject { ColorScheme::REGISTRY }

        it "contains all the valid color schemes" do
          assert_equal %w[default solarized nord], subject.keys
        end
      end

      describe "#initialize" do
        subject { ColorScheme.new(config: ::AiStatusLine::Terminal::Config.new) }

        it "has a primary color value" do
          refute_nil subject.primary
        end

        it "has a status_info color value" do
          refute_nil subject.status_info
        end

        it "has a status_warning color value" do
          refute_nil subject.status_warning
        end

        it "has a status_alert color value" do
          refute_nil subject.status_alert
        end

        it "has a default color value" do
          refute_nil subject.text
        end

        it "can choose a specific color theme" do
          ::AiStatusLine::Terminal::Config.any_instance.stubs(:color_scheme).returns("nord")

          assert_equal ColorScheme::NORD.name.downcase, subject.name.downcase
        end

        it "is case insensitive when finding color schemes" do
          ::AiStatusLine::Terminal::Config.any_instance.stubs(:color_scheme).returns("NoRd")

          assert_equal ColorScheme::NORD.name.downcase, subject.name.downcase
        end
      end

      describe "#colorize" do
        subject { ColorScheme.new(config: ::AiStatusLine::Terminal::Config.new) }

        it "sets the color of the text and appends a reset value" do
          result = subject.colorize(:status_warning) { "this is some text" }
          expected = "#{ColorScheme::DEFAULT.status_warning}this is some text#{ColorScheme::DEFAULT.text}"

          assert_equal expected, result
        end

        it "works for every known color property" do
          %i[primary status_info status_warning status_alert text].each do |color|
            result = subject.colorize(color) { "this is some text" }
            expected = "#{ColorScheme::DEFAULT.public_send(color)}this is some text#{ColorScheme::DEFAULT.text}"

            assert_equal expected, result
          end
        end
      end

      describe "#colorize_range" do
        subject { ColorScheme.new(config: ::AiStatusLine::Terminal::Config.new) }

        it "uses status_alert for values >= 90" do
          result = subject.colorize_range(90) { "i'm an alert!" }
          expected = "#{ColorScheme::DEFAULT.status_alert}i'm an alert!#{ColorScheme::DEFAULT.text}"

          assert_equal expected, result
        end

        it "uses staus_warning for values between 70 and 89" do
          result = subject.colorize_range(70) { "i'm a warning!" }
          expected = "#{ColorScheme::DEFAULT.status_warning}i'm a warning!#{ColorScheme::DEFAULT.text}"

          assert_equal expected, result
        end

        it "uses status_info for values below 70" do
          result = subject.colorize_range(69) { "i'm some info!" }
          expected = "#{ColorScheme::DEFAULT.status_info}i'm some info!#{ColorScheme::DEFAULT.text}"

          assert_equal expected, result
        end

        it "uses the integer itself when no block is given" do
          result = subject.colorize_range(40)
          expected = "#{ColorScheme::DEFAULT.status_info}40#{ColorScheme::DEFAULT.text}"

          assert_equal expected, result
        end
      end
    end
  end
end
