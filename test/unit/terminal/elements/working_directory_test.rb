# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class WorkingDirectoryTest < ::Minitest::Test
    describe "WorkingDirectory" do
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

      subject { WorkingDirectory.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        context "when the working directory is NOT a git repository" do
          before { ::AiStatusLine::Terminal::Utilities::Git.any_instance.stubs(:current_branch).returns(nil) }

          context "when the directory is not in the user's home folder" do
            it "shows the full path" do
              result = subject.render(color_scheme)

              assert_equal "/current/working/directory", result
            end
          end

          context "when the directory IS in the user's home folder" do
            before { Dir.stubs(:home).returns("/current/working") }

            it "shows an abbreviated path" do
              result = subject.render(color_scheme)

              assert_equal "~/directory", result
            end
          end
        end

        context "when the working directory IS a git repository" do
          before { ::AiStatusLine::Terminal::Utilities::Git.any_instance.stubs(:current_branch).returns("my/feature-branch") }

          context "when the directory is not in the user's home folder" do
            it "shows the full path, with the git branch colorized in the status_warning color" do
              theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
              result   = subject.render(color_scheme)
              expected = "/current/working/directory #{theme.status_warning}(my/feature-branch)#{theme.text}"

              assert_equal expected, result
            end
          end

          context "when the directory IS in the user's home folder" do
            before { Dir.stubs(:home).returns("/current/working") }

            it "shows an abbreviated path, with the git branch colorized in the status_warning color" do
              theme    = ::AiStatusLine::Terminal::ColorSchemes::ColorScheme::DEFAULT
              result   = subject.render(color_scheme)
              expected = "~/directory #{theme.status_warning}(my/feature-branch)#{theme.text}"

              assert_equal expected, result
            end
          end
        end
      end
    end
  end
end
