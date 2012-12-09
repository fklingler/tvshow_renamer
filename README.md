tvshow_renamer is a simple command line utility to rename automagically the tv show files you downloaded to a good format.

Thanks to [skamlet](https://github.com/skamlet) for his work on [tv-show-renamer](https://github.com/skamlet/tv-show-renamer), the java utility upon which I have based my work.

Feel free to contribute!


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

`tvshow_renamer [options] file|directory ...`

You can specify many files to rename.


### Options
* `-n TVSHOW_NAME` or `--name TVSHOW_NAME`  
  This option defines the TV show name used to rename the files. If the option is not present, the name will be asked first.

* `-f FORMAT` or `--format FORMAT`  
  This option defines the format for the new filenames.  
  `$n` will be substitued by the TV show name, `$s` by the season number, `$e` by the episode number.  
  The default format is : `$n - $sx$e`.

* `-l FILENAME` or `--log FILENAME`  
  This option makes the utility create a file inside the same directory as the renamed files containing the old and new names of the files. It can be useful to keep the episode or version names.

* `-r` or `--recursive`  
  If any directory is passed as parameter, this option makes the utility look recursively inside directories for files to rename.