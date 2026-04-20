# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class RateLimitsTest < ::Minitest::Test
    describe "RateLimits" do
      let(:model_data)   { ::AiStatusLine::Terminal::Providers::Claude.new(JSON.load_file(File.join(File.expand_path(TEST_ROOT), "fixtures", "claude_json_data.json"))) }
      let(:color_scheme) { ::AiStatusLine::Terminal::ColorSchemes::ColorScheme.new(config: ::AiStatusLine::Terminal::Config.new) }
      let(:data) do
        Data.new(
          workspace: model_data.workspace,
          model: model_data.model,
          context_window: model_data.context_window,
          cost: model_data.cost,
          rate_limits: model_data.rate_limits,
          git: ::AiStatusLine::Terminal::Utilities::Git.new(model_data.workspace.current_directory)
        )
      end

      subject { RateLimits.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        context "when usage is under 70%" do
          it "displays the consumption of five hour and weekly rate limits in the status_info color" do
            theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
            result   = subject.render(color_scheme)
            expected = "rate limit use: #{theme.status_info}24% (5h)#{theme.text}, #{theme.status_info}41% (7d)#{theme.text}"

            assert_equal expected, result
          end
        end

        context "when usage is between 70% and 89%" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:five_hour_usage).returns(70)
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:weekly_usage).returns(70)
          end

          it "displays the consumption of five hour and weekly rate limits in the status_warning color" do
            theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
            result   = subject.render(color_scheme)
            expected = "rate limit use: #{theme.status_warning}70% (5h)#{theme.text}, #{theme.status_warning}70% (7d)#{theme.text}"

            assert_equal expected, result
          end
        end

        context "when usage is 90% and above" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:five_hour_usage).returns(90)
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:weekly_usage).returns(90)
          end

          it "displays the consumption of five hour and weekly rate limits in the status_warning color" do
            theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
            result   = subject.render(color_scheme)
            expected = "rate limit use: #{theme.status_alert}90% (5h)#{theme.text}, #{theme.status_alert}90% (7d)#{theme.text}"

            assert_equal expected, result
          end
        end

        context "when five hour and weekly usage span different color thresholds" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:five_hour_usage).returns(20)
            ::AiStatusLine::Terminal::Providers::Claude::RateLimits.any_instance.stubs(:weekly_usage).returns(90)
          end

          it "displays the five hour and weekly consumption in different colors" do
            theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
            result   = subject.render(color_scheme)
            expected = "rate limit use: #{theme.status_info}20% (5h)#{theme.text}, #{theme.status_alert}90% (7d)#{theme.text}"

            assert_equal expected, result
          end
        end
      end
    end
  end
end
