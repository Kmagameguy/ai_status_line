# frozen_string_literal: true

require "yaml"
require "open3"

module AiStatusLine
  module Terminal
    autoload :Buffer,             "ai_status_line/terminal/buffer"
    autoload :Config,             "ai_status_line/terminal/config"
    autoload :StatusLineRenderer, "ai_status_line/terminal/status_line_renderer"

    module Utilities
      autoload :Git,              "ai_status_line/terminal/utilities/git"
    end

    module Providers
      autoload :Base,             "ai_status_line/terminal/providers/base"
      autoload :Claude,           "ai_status_line/terminal/providers/claude"
    end

    module ColorSchemes
      autoload :ColorScheme,      "ai_status_line/terminal/color_schemes/color_scheme"
      autoload :Schemes,          "ai_status_line/terminal/color_schemes/schemes"
    end

    module Elements
      autoload :Base,             "ai_status_line/terminal/elements/base"
      autoload :ContextUsed,      "ai_status_line/terminal/elements/context_used"
      autoload :Data,             "ai_status_line/terminal/elements/data"
      autoload :Model,            "ai_status_line/terminal/elements/model"
      autoload :RateLimits,       "ai_status_line/terminal/elements/rate_limits"
      autoload :REGISTRY,         "ai_status_line/terminal/elements/registry"
      autoload :SessionCost,      "ai_status_line/terminal/elements/session_cost"
      autoload :SessionLength,    "ai_status_line/terminal/elements/session_length"
      autoload :TokenUsage,       "ai_status_line/terminal/elements/token_usage"
      autoload :WorkingDirectory, "ai_status_line/terminal/elements/working_directory"
    end
  end
end
