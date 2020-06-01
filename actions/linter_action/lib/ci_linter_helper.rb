require 'json'
require 'open3'

class LinterRunner
  class << self

    def execute()
      source_offenses = source_branch_offenses
      target_offenses = target_branch_offenses
      
      if source_offenses.fetch('summary').fetch('offense_count') > target_offenses.fetch('summary').fetch('offense_count')
        source_branch_report = calculate_report_hash(source_offenses)
        target_branch_report = calculate_report_hash(target_offenses)

        show_offenses_added(source_branch_report, target_branch_report)
        
        exit 1
      else
        puts 'Congrats, you\'ve managed to not increase the number of offenses!'
        exit 0
      end
    end

    private 

    def files
      @files ||= `git diff --name-only HEAD origin/#{ARGV[0]}`.split("\n").select { |e| e =~ /.rb/ }
    end

    def source_branch_offenses
      JSON.parse(`rubocop --format json #{files.join(' ')}`)
    end

    def target_branch_offenses
      Open3.capture3("git checkout #{ARGV[0]}")

      JSON.parse(`rubocop --format json #{files.join(' ')}`)
    end

    def calculate_report_hash(offense_hash)
      report_hash = {}

      offense_hash.fetch('files').each do |file|
        report_hash[file.fetch('path')] = {}

        file.fetch('offenses').each do |offense|
          if report_hash.fetch(file.fetch('path')).key?(offense.fetch('cop_name'))
            report_hash[file.fetch('path')][offense.fetch('cop_name')] += 1
          else
            report_hash[file.fetch('path')][offense.fetch('cop_name')] = 1
          end
        end
      end

      report_hash
    end

    def show_offenses_added(source_branch_report, target_branch_report)
      source_branch_report.each do |file, offenses|

        offenses.each do |cop_name, quantity|
          result = quantity - (target_branch_report[file][cop_name] || 0)
          if result > 0
            print "#{result} #{cop_name} were added to #{file}"
            puts
          end
        end
      end
    end
  end
end

LinterRunner.execute