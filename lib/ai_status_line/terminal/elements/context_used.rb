# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class ContextUsed < Base
        BAR_SEGMENTS = 10
        private_constant :BAR_SEGMENTS

        def render(color_scheme)
          context = data.context_window
          color_scheme.colorize_range(context.percentage_used) do
            graph = sparkline(context.percentage_used)
            "ctx: #{graph} #{context.percentage_used}% (#{format_number(context.max_size)})"
          end
        end

        private

        def sparkline(percentage)
          fill_amount = (percentage.to_i / BAR_SEGMENTS).clamp(0, BAR_SEGMENTS)
          ("█" * fill_amount) + ("░" * (BAR_SEGMENTS - fill_amount))
        end

        def format_number(number)
          number.to_i.to_s.reverse.scan(/\d{1,3}/).join(",").reverse
        end
      end
    end
  end
end
