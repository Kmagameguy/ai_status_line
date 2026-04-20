# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class SessionCostTest < ::Minitest::Test
    describe "SessionCost" do
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

      subject { SessionCost.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        it "displays the total cost of the active session in USD, in the status_warning color" do
          theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
          result   = subject.render(color_scheme)
          expected = "#{theme.status_warning}session cost: $0.01#{theme.text}"

          assert_equal expected, result
        end

        it "rounds costs to the nearest cent" do
          ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_total).returns(0.03485719829547)
          theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
          result   = subject.render(color_scheme)
          expected = "#{theme.status_warning}session cost: $0.03#{theme.text}"

          assert_equal expected, result
        end
      end
    end
  end
end
