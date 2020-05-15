require 'json'

class Runner

    class << self
        def execute
            print commit_offenses["summary"], "\n"
            print previous_commit_offenses["summary"], "\n"

            if commit_offenses["summary"]["offense_count"] > previous_commit_offenses["summary"]["offense_count"]
                print("DEU ERRADO")
                exit 1
            else
                print("DEU CERTO")
                exit 0
            end
        end

        def commit_offenses
            JSON.parse(`rubocop --format json`)
        end
  
        def previous_commit_offenses
            `git checkout . && git checkout HEAD^`
            JSON.parse(`rubocop --format json`)
        end
    end
end

Runner.execute