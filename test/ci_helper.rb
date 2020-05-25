# frozen_string_literal: true

require 'json'
require 'open3'
require 'pry'
class Runner
  class << self
    attr_reader :offenses

    def initialize
      @offenses = {}
    end

    def execute
      pr_offenses = get_pr_offenses
      master_offenses = get_master_offenses

      binding.pry
      if pr_offenses["summary"]["offense_count"].size > master_offenses["summary"]["offense_count"].size
        pr_offenses["files"].each do |file|
          print file
        end
        print "Olha só"
        exit 1
      else
        print "Deu bom"
        exit 0
      end
    end
    private

    attr_writer :offenses

    def files
      @files ||= `git diff --name-only HEAD HEAD~1`.split("\n").select { |e| e =~ /.rb/ }
    end

    def get_pr_offenses
      JSON.parse(`rubocop --format json #{files.join(' ')}`)
    end

    def get_master_offenses
      Open3.capture3('git checkout . && git checkout HEAD^')

      JSON.parse(`rubocop --format json #{files.join(' ')}`)
    end
  end
end

print Runner.execute