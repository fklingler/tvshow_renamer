require 'optparse'

module TVShowRenamer
  class Runner
    def self.start
      options = {}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: tvshow_renamer [options] file|directory ..."

        opts.on("-n", "--name TVSHOW_NAME", "Log all renames to FILENAME, inside the TV show files directory") do |tvshow_name|
          options[:tvshow_name] = tvshow_name
        end

        opts.on("-l", "--log FILENAME", "Log all renames to FILENAME, inside the TV show files directory") do |log_file|
          options[:log_file] = log_file
        end

        opts.on("-r", "--recursive", "If passed a directory, look recursively inside it for files to rename") do |recursive|
          options[:recursive] = recursive
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

      if ARGV.empty?
        puts opts
      else
        options[:tvshow_name] ||= CLI.prompt 'Please enter the name of the TV Show for these files : '
        Renamer.new(options).rename(ARGV)
      end
    end
  end
end