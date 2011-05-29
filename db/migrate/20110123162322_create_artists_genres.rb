class CreateArtistsGenres < ActiveRecord::Migration
  def self.up
    create_table :artists_genres, :id => false do |t|
      t.belongs_to :artist
      t.belongs_to :genre
    end
  end

  def self.down
    drop_table :artists_genres
  end
end
