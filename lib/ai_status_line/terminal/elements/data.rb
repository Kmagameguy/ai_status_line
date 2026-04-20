# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      Data = Struct.new(:workspace, :model, :context_window, :cost, :rate_limits, :git)
      public_constant :Data
    end
  end
end
