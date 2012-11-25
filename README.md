tvshow_renamer is a simple command line utility to rename automagically the tv show files you downloaded to a good format.

Thanks to [skamlet](https://github.com/skamlet) for his work on [tv-show-renamer](https://github.com/skamlet/tv-show-renamer), the java utility upon which I have based my work.


Example
-------

Files like these ones:

* FamousShow.S05E01.DVDRip.XviD-BLAH.avi
* FamousShow.S05E02.DVDRip.XviD-BLAH.avi

Will be renamed like this:

* FamousShow - 05x01.avi
* FamousShow - 05x02.avi


Installation
------------

`gem install tvshow_renamer`


Usage
-----

`tvshow_renamer [options] <tvshow_name> file|directory ...`

You can specify many files to rename.

The option `-l FILENAME` ou `--log FILENAME` will make the utility create a file inside the same directory as the renamed files containing the old and new names of the files. It can be useful to keep the episode or version names.