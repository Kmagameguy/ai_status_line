# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class SessionLength < Base
        MS_PER_SECOND = 1_000
        MS_PER_MINUTE = 60 * MS_PER_SECOND
        MS_PER_HOUR   = 60 * MS_PER_MINUTE
        MS_PER_DAY    = 24 * MS_PER_HOUR
        MS_PER_WEEK   =  7 * MS_PER_DAY

        private_constant :MS_PER_SECOND
        private_constant :MS_PER_MINUTE
        private_constant :MS_PER_HOUR
        private_constant :MS_PER_DAY
        private_constant :MS_PER_WEEK

        def render(_color_scheme)
          "⏱️ #{format_duration(data.cost.session_length_in_ms)}"
        end

        private

        def format_duration(ms)
          visible_intervals = time_intervals(ms).drop_while { |_label, value| value.zero? }
          visible_intervals = [["s", 0]] if visible_intervals.empty?
          visible_intervals
            .map { |label, value| "#{value}#{label}" }
            .join(" ")
        end

        def time_intervals(ms)
          weeks,   ms = ms.divmod(MS_PER_WEEK)
          days,    ms = ms.divmod(MS_PER_DAY)
          hours,   ms = ms.divmod(MS_PER_HOUR)
          minutes, ms = ms.divmod(MS_PER_MINUTE)
          seconds     = ms / MS_PER_SECOND

          { "w" => weeks, "d" => days, "h" => hours, "m" => minutes, "s" => seconds }
        end
      end
    end
  end
end
