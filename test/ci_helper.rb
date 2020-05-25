# frozen_string_literal: true

require 'json'
require 'open3'

class Runner
  class << self
    attr_reader :offenses

    def initialize
      @offenses = {}
    end

    def execute

      if pr_offenses["files"][0]["offenses"].size > master_offenses["files"][0]["offenses"].size
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

    def pr_offenses
      pr_raw_data = JSON.parse(`rubocop --format json #{files.join(' ')}`)
      new_offenses = pr_raw_data
    end

    def master_offenses
      Open3.capture3('git checkout . && git checkout HEAD^')

      master_raw_data = JSON.parse(`rubocop --format json #{files.join(' ')}`)
      old_offenses = master_raw_data
    end

    def new_offenses
      offenses[:new_offenses] || {}
    end

    def fixed_offenses
      offenses[:fixed_offenses] || {}
    end

    def old_offenses
      offenses[:old_offenses] || {}
    end
  end
end

print Runner.execute