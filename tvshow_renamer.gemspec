# encoding: utf-8
require File.expand_path('../lib/tvshow_renamer/version', __FILE__)

Gem::Specification.new do |s|
  s.name              = "tvshow_renamer"
  s.version           = TVShowRenamer::VERSION
  s.license           = 'MIT'
  s.author            = "François Klingler"
  s.email             = "francois@fklingler.com"
  s.homepage          = "http://github.com/fklingler/tvshow_renamer"
  s.summary           = "TV Show files renamer"
  s.description       = "Utility to rename TV Show files to a correct format"

  s.files             = %w( LICENSE README.md Rakefile )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*")

  s.executables       = %w( tvshow_renamer )
end
