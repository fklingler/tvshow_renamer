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
      filename = File.expand_path(filename)
      extension = File.extname(filename)

      if EXTENSIONS.include?(extension.downcase)
        basename = File.basename(filename)
        detected_season, detected_episode = get_season_and_episode(basename)

        season = detected_season
        episode = detected_episode

        rename_ok = false
        until rename_ok
          new_basename = format_filename(@tvshow_name, season, episode, extension)
          print "Rename \"#{basename}\" to \"#{new_basename}\" ? (yneh) "
          $stdout.flush
          rename_value = $stdin.gets.chomp.strip
          case rename_value.downcase
          when 'y'
            new_filename = File.join(File.dirname(filename), new_basename)
            if File.exists?(new_filename)
              override_ok = false
              until override_ok
                print "File \"#{new_basename}\" already exists. Override ? (yn) "
                $stdout.flush
                override_value = $stdin.gets.chomp.strip
                case override_value
                when 'y'
                  FileUtils.mv filename, new_filename
                  override_ok = true
                  rename_ok = true
                when 'n'
                  override_ok = true
                end
              end
            else
              FileUtils.mv filename, new_filename
              rename_ok = true
            end
          when 'n'
            rename_ok = true
          when 'e'
            season = edit_value "Season", detected_season
            episode = edit_value "Episode", detected_episode
          when '?', 'h'
            puts "y: Yes, n: No, e: Edit"
          end
        end
      end
    end

    def get_season_and_episode(basename)
      regex = /(?<season>\d{1,2})(e|x|\.)?(?<episode>\d{2,})/i
      match = regex.match basename
      [match[:season].to_i, match[:episode].to_i]
    end

    def format_filename(tvshow_name, season, episode, extension)
      "#{tvshow_name} - %02ix%02i#{extension}" % [season, episode]
    end

    def edit_value(prompt, value)
      ok = false
      until ok
        print "#{prompt} (#{value}) : "
        $stdout.flush
        str = $stdin.gets.chomp.strip
        if str.empty?
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
