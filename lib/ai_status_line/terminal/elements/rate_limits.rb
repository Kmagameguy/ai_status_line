# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class RateLimits < Base
        def render(color_scheme)
          five_hour = data.rate_limits.five_hour_usage
          weekly    = data.rate_limits.weekly_usage

          five_hour_text = color_scheme.colorize_range(five_hour) { "#{five_hour.round}% (5h)" }
          weekly_text    = color_scheme.colorize_range(weekly) { "#{weekly.round}% (7d)" }

          "rate limit use: #{five_hour_text}, #{weekly_text}"
        end
      end
    end
  end
end
