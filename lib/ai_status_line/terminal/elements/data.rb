# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      Data = ::Data.define(:workspace, :model, :context_window, :cost, :rate_limits, :git)
    end
  end
end
