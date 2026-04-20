# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module ColorSchemes
      class ColorScheme
        Scheme = Struct.new(:name, :primary, :status_info, :status_warning, :status_alert, :text)
        private_constant :Scheme

        DEFAULT = Scheme.new(
          name: "Default",
          primary:        "\033[36m",
          status_info:    "\033[32m",
          status_warning: "\033[33m",
          status_alert:   "\033[31m",
          text:           "\033[0m"
        ).freeze
        public_constant :DEFAULT

        SOLARIZED = Scheme.new(
          name: "Solarized",
          primary:        "\033[38;5;33m",
          status_info:    "\033[38;5;64m",
          status_warning: "\033[38;5;136m",
          status_alert:   "\033[38;5;160m",
          text:           "\033[38;5;244m"
        ).freeze
        public_constant :SOLARIZED

        NORD = Scheme.new(
          name: "Nord",
          primary:        "\033[38;5;111m",
          status_info:    "\033[38;5;108m",
          status_warning: "\033[38;5;179m",
          status_alert:   "\033[38;5;131m",
          text:           "\033[38;5;252m"
        ).freeze
        public_constant :NORD

        REGISTRY = {
          "default"   => DEFAULT,
          "solarized" => SOLARIZED,
          "nord"      => NORD
        }.freeze
        public_constant :REGISTRY

        def initialize(config:)
          @scheme = REGISTRY.fetch(config.color_scheme.to_s.downcase, DEFAULT)
        end

        def name
          scheme.name
        end

        def primary
          scheme.primary
        end

        def status_info
          scheme.status_info
        end

        def status_warning
          scheme.status_warning
        end

        def status_alert
          scheme.status_alert
        end

        def text
          scheme.text
        end

        def colorize(color)
          "#{scheme.public_send(color)}#{yield}#{scheme.text}"
        end

        def colorize_range(integer)
          color =
            case Integer(integer, 0)
            when 90..Float::INFINITY then scheme.status_alert
            when 70..89 then scheme.status_warning
            else scheme.status_info
            end

          "#{color}#{block_given? ? yield : integer}#{scheme.text}"
        end

        private

        attr_reader :scheme
      end
    end
  end
end
