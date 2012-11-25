# encoding: utf-8
require 'fileutils'

module TVShowRenamer
  class Renamer
    attr_accessor :tvshow_name

    EXTENSIONS = %w( .mkv .avi .mp4 .srt )

    def initialize(tvshow_name, options = {})
      @tvshow_name = tvshow_name
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
      filename = File.expand_path(filename)
      extension = File.extname(filename)

      if EXTENSIONS.include?(extension.downcase)
        dirname = File.dirname(filename)
        basename = File.basename(filename)

        FileUtils.mv filename, File.join(dirname, new_basename(basename))
      end
    end

    def new_basename(basename)
      regex = /(?<season>\d{1,2})(e|x|\.)?(?<episode>\d{2,})/i
      match = regex.match basename
      "#{@tvshow_name} - %02ix%02i#{File.extname(basename)}" % [match[:season], match[:episode]]
    end
  end
end
