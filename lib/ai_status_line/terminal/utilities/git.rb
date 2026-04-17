# frozen_string_literal: true

require "open3"

module AiStatusLine
  module Terminal
    module Utilities
      class Git
        def initialize(working_directory)
          @working_directory = working_directory
        end

        def current_branch
          return unless working_directory

          out, status = Open3.capture2("git", "-c", working_directory, "symbolic-ref", "--short", "HEAD")
          out.strip if status.success?
        end

        private

        attr_reader :working_directory
      end
    end
  end
end
