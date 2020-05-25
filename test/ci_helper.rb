# frozen_string_literal: true

require 'json'

class Runner
  class << self
    attr_reader :offenses

    def initialize
      @offenses = {}
    end

    def execute
      print pr_offenses
      print master_offenses
    end
    private

    attr_writer :offenses

    def pr_offenses
      pr_raw_data = `rubocop --format json #{files.join(' ')}`
      new_offenses = pr_raw_data
    end

    def master_offenses
      Open3.capture3('git checkout . && git checkout HEAD^')

      master_raw_data = `rubocop --format json #{files.join(' ')}`
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