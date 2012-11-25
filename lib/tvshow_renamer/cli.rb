require 'optparse'

module TVShowRenamer
  class CLI
    def self.start
      options = {}
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
  end
end