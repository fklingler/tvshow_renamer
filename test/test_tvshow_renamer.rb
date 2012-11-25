require 'test/unit'
require 'tvshow_renamer'

class TVShowRenamerTest < Test::Unit::TestCase
  TVSHOW_NAME = 'Famous Show'

  def test_detect_season_and_episode
    {
      'FamousShow.S05E01.DVDRip.XviD-BLAH.avi' => [5, 1],
      'FamousShow.12x03.DVDRip.XviD-BLAH.avi'  => [12,3],
      'FamousShow.0103.720p.mkv'               => [1, 3],
      'FS.503.avi'                             => [5, 3],
      'Famous.Show.03.04.avi'                  => [3, 4],
      'Famous-Show.04x00.srt'                  => [4, 0],
    }.each do |k,v|
      tvfile = TVShowRenamer::TVShowFile.new(TVSHOW_NAME, k)
      tvfile.detect_season_and_episode
      
      assert_equal v, [tvfile.season, tvfile.episode]
    end
  end

  def test_new_basename
    tvfile = TVShowRenamer::TVShowFile.new(TVSHOW_NAME, 'test.mkv')
    tvfile.season = 1

    tvfile.episode = 2
    assert_equal 'Famous Show - 01x02.mkv', tvfile.new_basename

    tvfile.episode = 101
    assert_equal 'Famous Show - 01x101.mkv', tvfile.new_basename
  end
end