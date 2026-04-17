# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Providers
      class Base
        attr_reader :workspace, :model, :context_window, :cost, :rate_limits

        class Workspace
          attr_reader :current_directory
        end

        class Model
          attr_reader :current
        end

        class ContextWindow
          attr_reader :percentage_used, :max_size, :total_input_tokens, :total_output_tokens
        end

        class Cost
          attr_reader :session_total, :session_length_in_ms
        end

        class RateLimits
          attr_reader :five_hour_usage, :weekly_usage
        end
      end
    end
  end
end
