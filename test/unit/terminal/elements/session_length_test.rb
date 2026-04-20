# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Elements
  class SessionLengthTest < ::Minitest::Test
    describe "SessionLength" do
      let(:one_week)             { SessionLength.const_get(:MS_PER_WEEK) }
      let(:three_days)           { SessionLength.const_get(:MS_PER_DAY) * 3 }
      let(:six_hours)            { SessionLength.const_get(:MS_PER_HOUR) * 6 }
      let(:twelve_minutes)       { SessionLength.const_get(:MS_PER_MINUTE) * 12 }
      let(:twenty_seven_seconds) { SessionLength.const_get(:MS_PER_SECOND) * 27 }

      let(:session_length) { 0 }

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

      subject { SessionLength.new(data) }
      before  { ::AiStatusLine::Terminal::Config.any_instance.stubs(:load_config_file).returns({}) }

      describe "#render" do
        context "when the session is seconds long" do
          before do
            session_length = twenty_seven_seconds
            ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_length_in_ms).returns(session_length)
          end

          it "only displays the seconds interval" do
            result   = subject.render(color_scheme)
            expected = "⏱️ 27s"

            assert_equal expected, result
          end
        end

        context "when the session is minutes long" do
          before do
            session_length = twelve_minutes + twenty_seven_seconds
            ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_length_in_ms).returns(session_length)
          end

          it "displays the minutes and seconds intervals" do
            result   = subject.render(color_scheme)
            expected = "⏱️ 12m 27s"

            assert_equal expected, result
          end
        end

        context "when the session is hours long" do
          before do
            session_length = six_hours + twelve_minutes + twenty_seven_seconds
            ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_length_in_ms).returns(session_length)
          end

          it "displays the hours, minutes, and seconds intervals" do
            result   = subject.render(color_scheme)
            expected = "⏱️ 6h 12m 27s"

            assert_equal expected, result
          end
        end

        context "when the session is days long" do
          before do
            session_length = three_days + six_hours + twelve_minutes + twenty_seven_seconds
            ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_length_in_ms).returns(session_length)
          end

          it "displays the days, hours, minutes, and seconds intervals" do
            result   = subject.render(color_scheme)
            expected = "⏱️ 3d 6h 12m 27s"

            assert_equal expected, result
          end
        end

        context "when the session is over a week long" do
          before do
            session_length = one_week + three_days + six_hours + twelve_minutes + twenty_seven_seconds
            ::AiStatusLine::Terminal::Providers::Claude::Cost.any_instance.stubs(:session_length_in_ms).returns(session_length)
          end

          it "displays the weeks, days, hours, minutes, and seconds intervals" do
            result   = subject.render(color_scheme)
            expected = "⏱️ 1w 3d 6h 12m 27s"

            assert_equal expected, result
          end
        end
      end
    end
  end
end
