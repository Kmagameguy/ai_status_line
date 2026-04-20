# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Providers
  class ClaudeTest < ::Minitest::Test
    describe "Claude" do
      let(:model_data) do
        JSON.load_file(File.join(TEST_ROOT, "fixtures", "claude_json_data.json"))
      end

      let(:claude) { Claude.new(model_data) }

      describe "Workspace" do
        describe "#initialize" do
          it "has values from the json" do
            refute_nil claude.workspace.current_directory
          end

          it "sets defaults when json data is not present" do
            model_data.delete("workspace")

            assert_equal "empty", claude.workspace.current_directory
          end
        end
      end

      describe "Model" do
        describe "#initialize" do
          it "has values from the json" do
            refute_nil claude.model.current
          end

          it "sets defaults when json data is not present" do
            model_data.delete("model")

            assert_equal "none", claude.model.current
          end
        end
      end

      describe "ContextWindow" do
        describe "#initialize" do
          it "has values from the json" do
            refute_nil claude.context_window.percentage_used
            refute_nil claude.context_window.max_size
            refute_nil claude.context_window.total_input_tokens
            refute_nil claude.context_window.total_output_tokens
          end

          it "sets defaults when json data is not present" do
            model_data.delete("context_window")

            assert_predicate(claude.context_window.percentage_used, :zero?)
            assert_predicate(claude.context_window.max_size, :zero?)
            assert_predicate(claude.context_window.total_input_tokens, :zero?)
            assert_predicate(claude.context_window.total_output_tokens, :zero?)
          end
        end
      end

      describe "Cost" do
        describe "#initialize" do
          it "has values from the json" do
            refute_nil claude.cost.session_total
            refute_nil claude.cost.session_length_in_ms
          end

          it "sets defaults when json data is not present" do
            model_data.delete("cost")

            assert_predicate(claude.cost.session_total, :zero?)
            assert_predicate(claude.cost.session_length_in_ms, :zero?)
          end
        end
      end

      describe "RateLimits" do
        describe "#initialize" do
          it "has values from the json" do
            refute_nil claude.rate_limits.five_hour_usage
            refute_nil claude.rate_limits.weekly_usage
          end

          it "sets defaults when json data is not present" do
            model_data.delete("rate_limits")

            assert_predicate(claude.rate_limits.five_hour_usage, :zero?)
            assert_predicate(claude.rate_limits.weekly_usage, :zero?)
          end
        end
      end
    end
  end
end
