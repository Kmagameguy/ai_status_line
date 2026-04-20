# frozen_string_literal: true

require "test_helper"

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

      subject { StatusLineRenderer.new(data: data, config: ::AiStatusLine::Terminal::Config.new, color_scheme: color_scheme) }
      before  do
        ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({})
        ::AiStatusLine::Terminal::Utilities::Git.any_instance.stubs(:current_branch).returns(nil)
      end

      describe "#render!" do
        it "assembles the data elements and config into lines" do
          assert_equal 3, subject.__send__(:status_lines).count
        end

        it "ensures each element is a string" do
          subject.__send__(:status_lines).each do |status_line|
            assert_kind_of String, status_line
          end
        end

        # this test probably needs revision. Basically just counting the number of
        # expected pipes based on the number of elements & lines displayed by default
        # at time of writing.
        it "separates all elements with a pipe by default" do
          assert_equal 4, subject.__send__(:status_lines).join.scan("|").count
        end
      end
    end
  end
end
