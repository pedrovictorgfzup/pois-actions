require 'json'
require 'open3'

class Runner

    class << self
        attr_reader :offenses

        def initialize
        @offenses = {}
        end

        def execute
            STDOUT.puts("Inspecting:\n- #{files.join("\n- ")}")
            if files.any?
                STDOUT.puts("Inspecting:\n- #{files.join("\n- ")}")

                my_offense =  JSON.parse(`rubocop --format json #{files.join(' ')}`)
                master_offense = JSON.parse(master_offenses)

                if my_offense["summary"]["offense_count"] > master_offense["summary"]["offense_count"]
                    exit 1
                else
                    exit 0
                end


            else
                STDOUT.puts('No files to inspect')
            end
        end
  
        private
  
        attr_writer :offenses
  
        def files
              @files ||= `git diff --name-only HEAD HEAD~1`.split("\n").select { |e| e =~ /.rb/ }

        end
  
        def pr_offenses
    #   pr_raw_data = `rubocop --auto-gen-config --exclude-limit 2000 --format j #{files.join(' ')}`
    #   RubcopOutputParser.call(pr_raw_data)
        end
  
        def master_offenses
            # Open3.capture3('git checkout . && git checkout HEAD^')
            `git checkout . && git checkout HEAD^`
            `rubocop --format json #{files.join(' ')}`
    #   RubcopOutputParser.call(master_raw_data)
        end
  
        def new_offenses
            offenses[:new_offenses] || {}
        end
  
        def fixed_offenses
            offenses[:fixed_offenses] || {}
        end
    end
end

Runner.execute