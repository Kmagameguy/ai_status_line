# frozen_string_literal: true

require "yaml"

module AiStatusLine
  module Terminal
    class Config
      DEFAULT_PATH = File.expand_path("../../../config.yml", __dir__)
      private_constant :DEFAULT_PATH

      DEFAULT_LINES = [
        %w[model working_directory],
        %w[context_used session_cost session_length],
        %w[token_usage rate_limits]
      ].freeze
      private_constant :DEFAULT_LINES

      def initialize(path: DEFAULT_PATH)
        @data = load_config_file(path)
        @data = {} unless @data.is_a?(Hash)
      end

      def color_scheme
        data["color_scheme"]
      end

      def lines
        data["lines"] || DEFAULT_LINES
      end

      private

      def load_config_file(path)
        YAML.safe_load_file(path) rescue {}
      end

      attr_reader :data
    end
  end
end
