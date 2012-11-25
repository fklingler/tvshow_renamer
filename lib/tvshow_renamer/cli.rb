require 'optparse'

module TVShowRenamer
  class CLI
    def self.start
      options = {}
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: tvshow_renamer [options] <tvshow_name> file|directory ..."

        opts.on("-v", "--verbose", "Run verbosely") do |v|
          options[:verbose] = v
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
      opts.parse!

      if ARGV.length <= 1
        puts opts
      else
        options[:tvshow_name] = ARGV.shift
        Renamer.new(options).rename(ARGV)
      end
    end
  end
end