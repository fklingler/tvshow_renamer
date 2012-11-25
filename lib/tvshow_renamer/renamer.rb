# encoding: utf-8
require 'fileutils'

module TVShowRenamer
  class Renamer
    def initialize(options = {})
      @options = options
    end

    def rename(entries = [])
      entries.each do |entry|
        if File.exists?(entry)
          if File.directory?(entry)
            rename_dir(entry)
          else
            rename_file(entry)
          end
        else
          $stderr.puts "Warning -- #{entry} does not exist!"
        end
      end
    end

    def rename_dir(dirname)
      puts "Processing directory #{dirname}" if @options[:verbose]
      Dir.glob(dirname + '/**').each do |filename|
        rename_file(filename)
      end
    end

    def rename_file(filename)
      # TODO
    end
  end
end
