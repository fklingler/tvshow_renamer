require 'test/unit'
require 'tvshow_renamer'

class TVShowRenamerTest < Test::Unit::TestCase
  TVSHOW_NAME = 'Famous Show'

  def setup
    @renamer = TVShowRenamer::Renamer.new(TVSHOW_NAME)
  end

  def test_new_basename
    tests = {
      'FamousShow.S05E01.DVDRip.XviD-BLAH.avi' => 'Famous Show - 05x01.avi',
      'FamousShow.12x03.DVDRip.XviD-BLAH.avi'  => 'Famous Show - 12x03.avi',
      'FamousShow.0103.720p.mkv'               => 'Famous Show - 01x03.mkv',
      'FS.503.avi'                             => 'Famous Show - 05x03.avi',
      'Famous.Show.03.04.avi'                  => 'Famous Show - 03x04.avi'
    }.each do |k,v|
      assert_equal v, @renamer.new_basename(k)
    end
  end
end