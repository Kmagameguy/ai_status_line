# frozen_string_literal: true

module AiStatusLine
  module Terminal
    module Elements
      class WorkingDirectory < Base
        def render(color_scheme)
          "#{short_directory} #{git_branch_text(color_scheme)}".strip
        end

        private

        def short_directory
          data.workspace.current_directory.sub(Dir.home, "~")
        end

        def git_branch_text(color_scheme)
          branch = data.git.current_branch
          return "" if branch.nil?

          color_scheme.colorize(:status_warning) { "(#{branch})" }
        end
      end
    end
  end
end
