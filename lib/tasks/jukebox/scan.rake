require 'jukebox/indexer'

namespace :jukebox do
  task :artists => :environment do
    Artist.all.each do |artist|
      puts " * Processing #{artist.name}"
      artist.update_metadata
    end
  end

  task :releases => :environment do
    Release.all.each do |release|
      puts " * Processing #{release.name}"
      release.update_metadata
    end
  end

  task :scan => :environment do
    Jukebox::Indexer.new
  end
end