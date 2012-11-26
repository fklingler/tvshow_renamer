# encoding: utf-8
require 'fileutils'

module TVShowRenamer
  class Renamer
    attr_accessor :tvshow_name

    EXTENSIONS = %w( .mkv .avi .mp4 .srt )
    NUMBER_REGEX = /\A\d+\z/

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
      @tvfile = TVShowFile.new @tvshow_name, File.expand_path(filename)

      if EXTENSIONS.include?(@tvfile.extname.downcase)
        @tvfile.detect_season_and_episode

        if @tvfile.detected_season && @tvfile.detected_episode
          renamed = prompt_rename
        else
          answered = false
          until answered
            case CLI.prompt("No season and episode values have been detected for this file, do you want to rename it ? (yn) ").downcase
            when 'y'
              @tvfile.season = CLI.prompt_edit_value("Season", nil, NUMBER_REGEX).to_i
              @tvfile.episode = CLI.prompt_edit_value("Episode", nil, NUMBER_REGEX).to_i
              renamed = prompt_rename
              answered = true
            when 'n'
              answered = true
            end
          end
        end
      end
      renamed
    end

    def prompt_rename
      renamed = answered = false
      until answered
        case CLI.prompt("Rename \"#{@tvfile.basename}\" to \"#{@tvfile.new_basename}\" ? (ynemqh) ").downcase
        when 'y'
          if @tvfile.filename == @tvfile.new_filename
            puts "The two filenames are the same."
          else
            if File.exists?(@tvfile.new_filename)
              renamed = answered = prompt_override
            else
              move_tvshow_file
              renamed = answered = true
            end
          end
        when 'n'
          answered = true
        when 'e'
          @tvfile.season = CLI.prompt_edit_value("Season", @tvfile.detected_season, NUMBER_REGEX)
          @tvfile.episode = CLI.prompt_edit_value("Episode", @tvfile.detected_episode, NUMBER_REGEX)
        when 'm'
          show_menu
        when 'q'
          exit
        when '?', 'h'
          puts "y: Yes, n: No, e: Edit, m: Menu, q: Quit"
        end
      end
      renamed
    end

    def prompt_override
      overrided = answered = false
      until answered
        case CLI.prompt("File \"#{@tvfile.new_basename}\" already exists. Override ? (yn) ").downcase
        when 'y'
          move_tvshow_file
          answered = true
          overrided = true
        when 'n'
          answered = true
          overrided = false
        end
      end
      overrided
    end

    def show_menu
      puts "Menu"
      puts "----"
      puts "1. Change TV Show name"
      puts "2. Change format (not yet available)"
      puts "q. Quit menu"
      puts "----"
      quit = false
      until quit
        case CLI.prompt("Choice : ")
        when '1'
          @tvfile.tvshow_name = CLI.prompt_edit_value("TV Show Name", @tvfile.tvshow_name)
        when '2'
          puts "You cannot change the format yet, sorry."
        when 'q'
          quit = true
        end
      end
    end

    def move_tvshow_file
      FileUtils.mv @tvfile.filename, @tvfile.new_filename
      log_rename
    end

    def log_rename
      if @options[:log_file]
        File.open(File.join(@tvfile.dirname, @options[:log_file]), 'a') do |file|
          file.puts "\"#{@tvfile.basename}\" => \"#{@tvfile.new_basename}\"\n"
        end
      end
    end
  end
end
