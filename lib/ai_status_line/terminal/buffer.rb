# frozen_string_literal: true

module AiStatusLine
  module Terminal
    class Buffer
      def initialize(model_json_data, terminal_config = Config.new)
        ai_model_data = detect_provider(model_json_data).new(model_json_data)
        git_data = Utilities::Git.new(ai_model_data.workspace.current_directory)
        data = element_data(ai_model_data, git_data)

        @renderer = StatusLineRenderer.new(
          data: data,
          config: terminal_config,
          color_scheme: ColorSchemes::ColorScheme.new(config: terminal_config)
        )
      end

      def render!
        renderer.render!
      end

      private

      def element_data(model_data, git_data)
        Elements::Data.new(
          workspace: model_data.workspace,
          model: model_data.model,
          context_window: model_data.context_window,
          cost: model_data.cost,
          rate_limits: model_data.rate_limits,
          git: git_data
        )
      end

      def detect_provider(model_json_data)
        return Providers::Claude if model_json_data.dig("model", "id").to_s.include?("claude")

        raise(ArgumentError, "Unsupported Provider!")
      end

      attr_reader :renderer
    end
  end
end
