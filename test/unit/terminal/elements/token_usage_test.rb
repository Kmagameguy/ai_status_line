# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class TokenUsageTest < ::Minitest::Test
    describe "TokenUsage" do
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

      subject { TokenUsage.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        context "when token use is under 1,000" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_input_tokens).returns(800)
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_output_tokens).returns(250)
          end

          it "displays the raw token counts" do
            result   = subject.render(color_scheme)
            expected = "tkn in: 800, out: 250"

            assert_equal expected, result
          end
        end

        context "when token use is over 1,000" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_input_tokens).returns(15_200)
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_output_tokens).returns(4_500)
          end

          it "displays the tokens with a (k) marker" do
            result   = subject.render(color_scheme)
            expected = "tkn in: 15.2k, out: 4.5k"

            assert_equal expected, result
          end
        end

        context "when token use is a mix of above and below 1,000" do
          before do
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_input_tokens).returns(15_200)
            ::AiStatusLine::Terminal::Providers::Claude::ContextWindow.any_instance.stubs(:total_output_tokens).returns(212)
          end

          it "displays tokens under 1,000 normally, and formats tokens above 1,000 with a (k) marker" do
            result   = subject.render(color_scheme)
            expected = "tkn in: 15.2k, out: 212"

            assert_equal expected, result
          end
        end
      end
    end
  end
end
