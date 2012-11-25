require 'test/unit'
require 'tvshow_renamer'

class TVShowRenamerTest < Test::Unit::TestCase
  TVSHOW_NAME = 'Famous Show'

  def setup
    @renamer = TVShowRenamer::Renamer.new(TVSHOW_NAME)
  end

  def test_get_season_and_episode
    {
      'FamousShow.S05E01.DVDRip.XviD-BLAH.avi' => [5, 1],
      'FamousShow.12x03.DVDRip.XviD-BLAH.avi'  => [12,3],
      'FamousShow.0103.720p.mkv'               => [1, 3],
      'FS.503.avi'                             => [5, 3],
      'Famous.Show.03.04.avi'                  => [3, 4],
      'Famous-Show.04x00.srt'                  => [4, 0],
    }.each do |k,v|
      assert_equal v, @renamer.get_season_and_episode(k)
    end
  end

  def test_format_filename
    assert_equal 'Famous Show - 01x02.mkv',
                 @renamer.format_filename(TVSHOW_NAME, 1, 2, '.mkv')
    assert_equal 'Famous Show - 01x101.mkv',
                 @renamer.format_filename(TVSHOW_NAME, 1, 101, '.mkv')
  end
end