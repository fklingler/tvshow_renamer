module TVShowRenamer
  class TVShowFile
    attr_reader :tvshow_name
    attr_reader :filename
    attr_accessor :season
    attr_accessor :episode
    attr_reader :detected_season
    attr_reader :detected_episode

    def initialize(tvshow_name, filename)
      @tvshow_name = tvshow_name
      @filename = filename
    end

    # Custom setters

    def season=(season)
      @season = season
      @new_basename = @new_filename = nil
    end

    def episode=(episode)
      @episode = episode
      @new_basename = @new_filename = nil
    end

    # Lazy getters

    def basename
      @basename ||= File.basename(@filename)
    end

    def dirname
      @dirname ||= File.dirname(@filename)
    end

    def extname
      @extname ||= File.extname(@filename)
    end

    def new_basename
      unless @new_basename
        @new_basename = "#{@tvshow_name} - %02ix%02i#{extname}" % [@season, @episode]
        @new_filename = nil
      end
      @new_basename
    end

    def new_filename
      @new_filename ||= File.join dirname, new_basename
    end

    # Active methods

    def detect_season_and_episode
      regex = /(?<season>\d{1,2})(e|x|\.)?(?<episode>\d{2,})/i
      match = regex.match basename
      if match && match[:season] && match[:episode]
        @detected_season = match[:season].to_i
        send :season=, @detected_season
        @detected_episode = match[:episode].to_i
        send :episode=, @detected_episode
      end
    end
  end
end