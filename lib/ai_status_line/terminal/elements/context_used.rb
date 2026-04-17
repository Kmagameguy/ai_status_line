# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class ContextUsed < Base
        BAR_SEGMENTS = 10

        def render(color_scheme)
          context = data.context_window
          color_scheme.colorize_range(context.percentage_used) do
            "ctx: #{sparkline(context.percentage_used)} #{context.percentage_used}% (#{context.max_size})"
          end
        end

        private

        def sparkline(percentage)
          fill_amount = (percentage.to_i / BAR_SEGMENTS).clamp(0, BAR_SEGMENTS)
          "█" * fill_amount + "░" * (BAR_SEGMENTS - fill_amount)
        end
      end
    end
  end
end
