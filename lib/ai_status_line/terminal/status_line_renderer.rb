# frozen_string_literal: true

module AiStatusLine
  module Terminal
    class StatusLineRenderer
      DEFAULT_SEPARATOR = " | "
      private_constant :DEFAULT_SEPARATOR

      def initialize(data:, config:, color_scheme:)
        @data         = data
        @config       = config
        @color_scheme = color_scheme
      end

      def render!
        status_lines.each { |line| puts line }
      end

      private

      attr_reader :data, :config, :color_scheme

      def status_lines
        config.lines.map do |line_elements|
          line_elements.map do |element|
            Elements::REGISTRY.fetch(element).new(data).render(color_scheme)
          end.join(DEFAULT_SEPARATOR)
        end
      end
    end
  end
end
