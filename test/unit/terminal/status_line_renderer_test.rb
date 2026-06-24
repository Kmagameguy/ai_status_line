# frozen_string_literal: true

require "test_helper"
require "stringio"

module AiStatusLine::Terminal
  class StatusLineRendererTest < ::Minitest::Test
    describe "StatusLineRenderer" do
      let(:model_data)   { ::AiStatusLine::Terminal::Providers::Claude.new(JSON.load_file(File.join(File.expand_path(TEST_ROOT), "fixtures", "claude_json_data.json"))) }
      let(:color_scheme) { ::AiStatusLine::Terminal::ColorSchemes::ColorScheme.new(config: ::AiStatusLine::Terminal::Config.new) }
      let(:data) do
        ::AiStatusLine::Terminal::Elements::Data.new(
          workspace: model_data.workspace,
          model: model_data.model,
          context_window: model_data.context_window,
          cost: model_data.cost,
          rate_limits: model_data.rate_limits,
          git: ::AiStatusLine::Terminal::Utilities::Git.new(model_data.workspace.current_directory)
        )
      end
      let(:io) { StringIO.new }

      subject { StatusLineRenderer.new(data: data, config: ::AiStatusLine::Terminal::Config.new, color_scheme: color_scheme, io: io) }
      before  do
        ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({})
        ::AiStatusLine::Terminal::Utilities::Git.any_instance.stubs(:current_branch).returns(nil)
      end

      describe "#render!" do
        it "assembles the data elements and config into lines" do
          subject.render!

          assert_equal 3, io.string.lines.count
        end

        it "renders the data in accordance with the configuration" do
          expected_string =
            "\e[36mOpus 🧠 (high)\e[0m | /current/working/directory\n" \
            "\e[32mctx: ░░░░░░░░░░ 8% (200,000)\e[0m | \e[33msession cost: $0.01\e[0m | \u23f1\ufe0f 45s\n" \
            "tkn in: 15.2k, out: 4.5k | rate limit use: \e[32m24% (5h)\e[0m, \e[32m41% (7d)\e[0m\n"
          subject.render!

          assert_equal expected_string, io.string
        end
      end
    end
  end
end
