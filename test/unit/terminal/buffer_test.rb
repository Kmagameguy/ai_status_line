# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal
  class BufferTest < ::Minitest::Test
    describe "Buffer" do
      it "raises when the data is from an unsupported provider" do
        assert_raises(ArgumentError, "Unsupported Provider!") do
          Buffer.new({"model" => { "id" => "Codex" } })
        end
      end

      it "assembles all the data and asks StatusLineRenderer to print the result" do
        StatusLineRenderer.any_instance.expects(:render!).once

        Buffer.new({"model" => { "id" => "claude-opus-4-7[1m]" } }).render!
      end
    end
  end
end
