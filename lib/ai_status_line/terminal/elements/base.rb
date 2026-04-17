# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class Base
        def initialize(data)
          @data = data
        end

        def render(_color_scheme)
          raise NotImplementedError, "Inheriting class must define #render"
        end

        private

        attr_reader :data
      end
    end
  end
end
