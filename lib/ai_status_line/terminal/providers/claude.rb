# frozen_string_literal: true

require_relative "base"

module AiStatusLine
  module Terminal
    module Providers
      class Claude < Base
        def initialize(claude_json_data)
          claude_json_data = {} unless claude_json_data.is_a?(Hash)
          @workspace       = Workspace.new(claude_json_data["workspace"])
          @model           = Model.new(claude_json_data["model"])
          @context_window  = ContextWindow.new(claude_json_data["context_window"])
          @cost            = Cost.new(claude_json_data["cost"])
          @rate_limits     = RateLimits.new(claude_json_data["rate_limits"])
        end

        class Workspace < Base::Workspace
          def initialize(options)
            options = {} unless options.is_a?(Hash)
            @current_directory = options["current_dir"] || "empty"
          end
        end

        class Model < Base::Model
          def initialize(options)
            options  = {} unless options.is_a?(Hash)
            @current = options["display_name"] || "none"
          end
        end

        class ContextWindow < Base::ContextWindow
          def initialize(options)
            options              = {} unless options.is_a?(Hash)
            @percentage_used     = options["used_percentage"] || 0
            @max_size            = options["context_window_size"] || 0
            @total_input_tokens  = options["total_input_tokens"] || 0
            @total_output_tokens = options["total_output_tokens"] || 0
          end
        end

        class Cost < Base::Cost
          def initialize(options)
            options               = {} unless options.is_a?(Hash)
            @session_total        = options["total_cost_usd"] || 0
            @session_length_in_ms = options["total_duration_ms"] || 0
          end
        end

        class RateLimits < Base::RateLimits
          def initialize(options)
            options          = {} unless options.is_a?(Hash)
            @five_hour_usage = options.dig("five_hour", "used_percentage") || 0
            @weekly_usage    = options.dig("seven_day", "used_percentage") || 0
          end
        end
      end
    end
  end
end
