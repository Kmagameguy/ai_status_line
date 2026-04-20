# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class ContextUsedTest < ::Minitest::Test
    describe "ContextUsed" do
      let(:model_data)   { ::AiStatusLine::Terminal::Providers::Claude.new(JSON.load_file(File.join(TEST_ROOT, "fixtures", "claude_json_data.json"))) }
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
      subject { ContextUsed.new(data) }

      describe "#render" do
        context "when usage is under 70%" do
          it "renders a sparkline and context usage statistics" do
            theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
            result   = subject.render(color_scheme)
            expected = "#{theme.status_info}ctx: ░░░░░░░░░░ 8% (200000)#{theme.text}"

            assert_equal expected, result
          end
        end
      end
    end
  end
end
