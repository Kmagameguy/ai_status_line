# frozen_string_literal: true

require "json"
$LOAD_PATH.unshift(File.join(__dir__, "lib"))
require "ai_status_line"

terminal_config = AiStatusLine::Terminal::Config.new
provider_data   = JSON.parse(ARGF.read) rescue {}

AiStatusLine::Terminal::Buffer.new(provider_data, terminal_config).render!
