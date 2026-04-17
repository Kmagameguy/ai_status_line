# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module ColorSchemes
      Scheme = Struct.new(:primary, :status_info, :status_warning, :status_alert, :text, keyword_init: true)

      DEFAULT = Scheme.new(
        primary:        "\033[36m",
        status_info:    "\033[32m",
        status_warning: "\033[33m",
        status_alert:   "\033[31m",
        text:           "\033[0m"
      ).freeze

      SOLARIZED = Scheme.new(
        primary:        "\033[38;5;33m",
        status_info:    "\033[38;5;64m",
        status_warning: "\033[38;5;136m",
        status_alert:   "\033[38;5;160m",
        text:           "\033[38;5;244m"
      ).freeze

      NORD = Scheme.new(
        primary:        "\033[38;5;111m",
        status_info:    "\033[38;5;108m",
        status_warning: "\033[38;5;179m",
        status_alert:   "\033[38;5;131m",
        text:           "\033[38;5;252m"
      ).freeze

      REGISTRY = {
        "default"   => DEFAULT,
        "solarized" => SOLARIZED,
        "nord"      => NORD
      }.freeze
    end
  end
end
