# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class Model < Base
        def render(color_scheme)
          color_scheme.colorize(:primary) { data.model.current }
        end
      end
    end
  end
end
