class AddArtistIdAndYearToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :year, :string
    add_column :tracks, :artist_id, :integer
  end

  def self.down
    remove_column :tracks, :year
    remove_column :tracks, :artist_id
  end
end
