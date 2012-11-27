require 'optparse'

module TVShowRenamer
  class Runner
    def self.start
      options = {}
      options[:format] = "$n - $sx$e"

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: tvshow_renamer [options] file|directory ..."

        opts.on("-n", "--name TVSHOW_NAME", "Define the TV show name used to rename the files") do |tvshow_name|
          options[:tvshow_name] = tvshow_name
        end

        opts.on("-f", "--format FORMAT",
          "Define the format for the new filenames - Default : \"$n - $sx$e\"",
          "$n will be substitued by the TV show name, $s by the season number, $e by the episode number") do |format|
          options[:format] = format
        end

        opts.on("-l", "--log FILENAME", "Log all renames to FILENAME, inside the TV show files directory") do |log_file|
          options[:log_file] = log_file
        end

        opts.on("-r", "--recursive", "If passed a directory, look recursively inside it for files to rename") do |recursive|
          options[:recursive] = recursive
        end

        opts.separator ""

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