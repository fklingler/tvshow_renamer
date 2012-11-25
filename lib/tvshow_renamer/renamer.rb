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
      puts "Renaming files in directory \"#{dirname}\""
      Dir.glob(dirname + '/**').each do |filename|
        rename_file(filename)
      end
    end

    def rename_file(filename)
      renamed = false
      tvfile = TVShowFile.new @tvshow_name, File.expand_path(filename)

      if EXTENSIONS.include?(tvfile.extname.downcase)
        tvfile.detect_season_and_episode

        if tvfile.detected_season && tvfile.detected_episode
          renamed = prompt_rename(tvfile)
        else
          answered = false
          until answered
            case CLI.prompt("No season and episode values have been detected for this file, do you want to rename it ? (yn) ").downcase
            when 'y'
              tvfile.season = CLI.prompt_edit_value "Season"
              tvfile.episode = CLI.prompt_edit_value "Episode"
              renamed = prompt_rename(tvfile)
              answered = true
            when 'n'
              answered = true
            end
          end
        end
      end
      renamed
    end

    def prompt_rename(tvfile)
      renamed = answered = false
      until answered
        case CLI.prompt("Rename \"#{tvfile.basename}\" to \"#{tvfile.new_basename}\" ? (yneh) ").downcase
        when 'y'
          if File.exists?(tvfile.new_filename)
            renamed = answered = prompt_override(tvfile)
          else
            move_tvshow_file(tvfile)
            renamed = answered = true
          end
        when 'n'
          answered = true
        when 'e'
          tvfile.season = CLI.prompt_edit_value "Season", tvfile.detected_season
          tvfile.episode = CLI.prompt_edit_value "Episode", tvfile.detected_episode
        when '?', 'h'
          puts "y: Yes, n: No, e: Edit"
        end
      end
      renamed
    end

    def prompt_override(tvfile)
      overrided = answered = false
      until answered
        case CLI.prompt("File \"#{tvfile.new_basename}\" already exists. Override ? (yn) ").downcase
        when 'y'
          move_tvshow_file(tvfile)
          answered = true
          overrided = true
        when 'n'
          answered = true
          overrided = false
        end
      end
      overrided
    end

    def move_tvshow_file(tvfile)
      FileUtils.mv tvfile.filename, tvfile.new_filename
      log_rename tvfile
    end

    def log_rename(tvfile)
      if @options[:log_file]
        File.open(File.join(tvfile.dirname, @options[:log_file]), 'a') do |file|
          file.puts "\"#{tvfile.basename}\" => \"#{tvfile.new_basename}\"\n"
        end
      end
    end
  end
end
