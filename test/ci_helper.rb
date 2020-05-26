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

      pr_report_hash = {}
      master_report_hash = {}
      
      if pr_offenses["summary"]["offense_count"] > master_offenses["summary"]["offense_count"]
        pr_offenses["files"].each do |file|
          pr_report_hash[file["path"]] = {}

          file["offenses"].each do |offense|
            if pr_report_hash[file["path"]].has_key?(offense["cop_name"])
              pr_report_hash[file["path"]][offense["cop_name"]] += 1
            else
              pr_report_hash[file["path"]][offense["cop_name"]] = 1
            end
          end
        end

        master_offenses["files"].each do |file|
          master_report_hash[file["path"]] = {}

          file["offenses"].each do |offense|
            if master_report_hash[file["path"]].has_key?(offense["cop_name"])
              master_report_hash[file["path"]][offense["cop_name"]] += 1
            else
              master_report_hash[file["path"]][offense["cop_name"]] = 1
            end
          end
        end


        print "Olha só pr: ", pr_report_hash, "\n\n\n"
        print "Olha só master: ", master_report_hash, "\n\n\n"

        pr_report_hash.each do |file, offenses|

          offenses.each do |cop_name, quantity|
            result = quantity - (master_report_hash[file][cop_name] || 0)
            if result > 0
              print "#{result} #{cop_name} were added to #{file}"
              puts
            elsif result < 0
              print "#{result} #{cop_name} were fixed in #{file}"
              puts
            end
          end

        end
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

Runner.execute


















