# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class Model < Base
        def render(color_scheme)
          model_details = data.model.current
          model_details += (" " + "🧠") if data.model.thinking?
          model_details += (" " + "(#{data.model.effort})") if data.model.effort

          color_scheme.colorize(:primary) { model_details }
        end
      end
    end
  end
end
