class AddArtistIdAndGenreIdIndexOnTaggings < ActiveRecord::Migration
  def self.up
    add_index :taggings, :genre_id
    add_index :taggings, :artist_id
    add_index :taggings, [:artist_id, :genre_id]
  end

  def self.down
  end
end
