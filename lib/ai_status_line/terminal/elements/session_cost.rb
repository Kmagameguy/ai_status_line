# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class SessionCost < Base
        def render(color_scheme)
          color_scheme.colorize(:status_warning) do
            "session cost: $#{data.cost.session_total.round(2)}"
          end
        end
      end
    end
  end
end
