require 'optparse'

module TVShowRenamer
  class CLI
    def self.start
      options = {cli: true}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: tvshow_renamer [options] <tvshow_name> file|directory ..."

        opts.on("-l", "--log FILENAME", "Log all renames to FILENAME, inside the TV show files directory") do |log_file|
          options[:log_file] = log_file
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts TVShowRenamer::VERSION
          exit
        end
      end
      opts.parse!

      if ARGV.length <= 1
        puts opts
      else
        tvshow_name = ARGV.shift
        Renamer.new(tvshow_name, options).rename(ARGV)
      end
    end

    def self.prompt(prompt)
      print prompt
      $stdout.flush
      $stdin.gets.chomp.strip
    end

    def self.prompt_edit_value(prompt, value = nil)
      prompt << " (#{value})" if value
      prompt << " : "
      ok = false
      until ok
        str = self.prompt prompt
        if value && str.empty?
          ok = true
        else
          if str =~ /0{1,}/ || str.to_i > 0
            value = str.to_i
            ok = true
          end
        end
      end
      value
    end
  end
end