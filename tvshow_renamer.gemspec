# encoding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name              = "tvshow_renamer"
  s.version           = '0.1'
  s.license           = 'MIT'
  s.author            = "François Klingler"
  s.email             = "francois@fklingler.com"
  s.homepage          = "http://github.com/fklingler/tvshow_renamer"
  s.summary           = "TV Show files renamer"
  s.description       = "Utility to rename TV Show files to a correct format"

  s.files             = Dir.glob("lib/**/*")
  s.executables       = %w( tvshow_renamer )
end
