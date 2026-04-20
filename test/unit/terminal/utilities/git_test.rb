# frozen_string_literal: true

require "test_helper"

module AiStatusLine::Terminal::Utilities
  class GitTest < ::Minitest::Test
    describe "Git" do
      let(:success_status) { Struct.new(:success?).new(true)  }
      let(:failure_status) { Struct.new(:success?).new(false) }
      let(:working_dir)    { "/home/user/project" }

      describe "#current_branch" do
        context "when working directory is not set" do
          subject { Git.new(nil) }

          it "is nil" do
            assert_nil subject.current_branch
          end
        end

        context "when working directory is not a git repository" do
          subject { Git.new(working_dir) }
          before  { Open3.stubs(:capture2).returns(["", failure_status]) }

          it "is nil" do
            assert_nil subject.current_branch
          end
        end

        context "when working directory is a git repository" do
          subject { Git.new(working_dir) }
          before { Open3.stubs(:capture2).returns(["main\n", success_status]) }

          it "shows the name of the active git branch" do
            assert_equal "main", subject.current_branch
          end
        end
      end
    end
  end
end
