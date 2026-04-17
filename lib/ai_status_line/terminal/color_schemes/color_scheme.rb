# frozen_string_literal: true

require_relative "scheme"

module AiStatusLine
  module Terminal
    module ColorSchemes
      class ColorScheme
        def initialize(config:)
          @scheme = ColorSchemes::REGISTRY.fetch(config.color_scheme.to_s.downcase, ColorSchemes::DEFAULT)
        end

        def colorize(color)
          "#{scheme.send(color)}#{yield}#{scheme.text}"
        end

        def colorize_range(integer)
          color = begin
            case integer.to_i
            when 90..Float::INFINITY then scheme.status_alert
            when 70..89 then scheme.status_warning
            else scheme.status_info
            end
          end

          "#{color}#{block_given? ? yield : integer}#{scheme.text}"
        end

        private

        attr_reader :scheme
      end
    end
  end
end
