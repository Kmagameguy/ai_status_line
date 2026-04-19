# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class TokenUsage < Base
        def render(_color_scheme)
          context = data.context_window
          "tkn in: #{format_count(context.total_input_tokens)}, out: #{format_count(context.total_output_tokens)}"
        end

        private

        def format_count(count)
          return count if Integer(count, 0) < 1_000

          "#{(count / 1_000.0).round(1)}k"
        end
      end
    end
  end
end
