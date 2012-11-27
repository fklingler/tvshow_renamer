require 'test/unit'
require 'tvshow_renamer'

class TVShowRenamerTest < Test::Unit::TestCase
  FORMAT = '$n - $sx$e'
  TVSHOW_NAME = 'Famous Show'

  def test_detect_season_and_episode
    options = {:format => FORMAT, :tvshow_name => TVSHOW_NAME}
    {
      'FamousShow.S05E01.DVDRip.XviD-BLAH.avi' => [5, 1],
      'FamousShow.12x03.DVDRip.XviD-BLAH.avi'  => [12,3],
      'FamousShow.0103.720p.mkv'               => [1, 3],
      'FS.503.avi'                             => [5, 3],
      'Famous.Show.03.04.avi'                  => [3, 4],
      'Famous-Show.04x00.srt'                  => [4, 0],
    }.each do |k,v|
      tvfile = TVShowRenamer::TVShowFile.new(options, k)
      tvfile.detect_season_and_episode
      
      assert_equal v, [tvfile.season, tvfile.episode]
    end
  end

  def test_new_basename
    options = {:format => FORMAT, :tvshow_name => TVSHOW_NAME}
    tvfile = TVShowRenamer::TVShowFile.new(options, 'test.mkv')
    tvfile.season = 1
    tvfile.episode = 2
    assert_equal 'Famous Show - 01x02.mkv', tvfile.new_basename

    options[:format] = '$n$s$e'
    tvfile.options_modified
    assert_equal 'Famous Show0102.mkv', tvfile.new_basename
  end
end