# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      REGISTRY = {
        "model"             => Model,
        "working_directory" => WorkingDirectory,
        "context_used"      => ContextUsed,
        "session_cost"      => SessionCost,
        "session_length"    => SessionLength,
        "token_usage"       => TokenUsage,
        "rate_limits"       => RateLimits
      }.freeze
      public_constant :REGISTRY
    end
  end
end
