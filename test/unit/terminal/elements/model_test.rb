# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class ModelTest < ::Minitest::Test
    describe "Model" do
      let(:json_data)    { JSON.load_file(File.join(File.expand_path(TEST_ROOT), "fixtures", "claude_json_data.json")) }
      let(:model_data)   { ::AiStatusLine::Terminal::Providers::Claude.new(json_data) }
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

      subject { Model.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        before do
          @theme = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
        end

        it "displays the text using the primary color" do
          result   = subject.render(color_scheme)
          expected = "#{@theme.primary}Opus 🧠 (high)#{@theme.text}"

          assert_equal expected, result
        end

        it "excludes the 🧠 emoji when thinking isn't available" do
          json_data.delete("thinking")

          expected = "#{@theme.primary}Opus (high)#{@theme.text}"
          result   = subject.render(color_scheme)

          assert_equal expected, result
        end

        it "excludes the 🧠 emoji when thinking is disabled" do
          json_data["thinking"]["enabled"] = false

          expected = "#{@theme.primary}Opus (high)#{@theme.text}"
          result   = subject.render(color_scheme)

          assert_equal expected, result
        end

        it "excludes the effort level when it isn't available" do
          json_data.delete("effort")

          expected = "#{@theme.primary}Opus 🧠#{@theme.text}"
          result   = subject.render(color_scheme)

          assert_equal expected, result
        end

        it "only displays the model name when thinking and effort aren't available" do
          json_data.delete("thinking")
          json_data.delete("effort")

          expected = "#{@theme.primary}Opus#{@theme.text}"
          result   = subject.render(color_scheme)

          assert_equal expected, result
        end
      end
    end
  end
end
