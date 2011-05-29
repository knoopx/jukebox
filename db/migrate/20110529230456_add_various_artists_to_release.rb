class AddVariousArtistsToRelease < ActiveRecord::Migration
  def self.up
    add_column :releases, :various_artists, :boolean, :default => false
    add_column :releases, :mbid, :string
    add_column :releases, :image_url, :string
    add_column :releases, :lastfm_url, :string
    add_column :releases, :listeners, :string
    add_column :releases, :play_count, :string
    add_column :releases, :summary, :text
    add_column :releases, :review, :text
    add_column :releases, :released_at, :date
  end

  def self.down
    remove_column :releases, :various_artists
    remove_column :releases, :mbid
    remove_column :releases, :image_url
    remove_column :releases, :lastfm_url
    remove_column :releases, :listeners
    remove_column :releases, :play_count
    remove_column :releases, :summary
    remove_column :releases, :review
    remove_column :releases, :released_at
  end
end
