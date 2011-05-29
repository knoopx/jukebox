class AddArtistMetadataColumns < ActiveRecord::Migration
  def self.up
    add_column :artists, :mbid, :string
    add_column :artists, :lastfm_url, :string

    add_column :artists, :listeners, :string
    add_column :artists, :play_count, :string

    add_column :artists, :image_url, :string
    add_column :artists, :summary, :text
    add_column :artists, :biography, :text

    add_column :artists, :similar_mbids, :text
  end

  def self.down
    remove_column :artists, :mbid
    remove_column :artists, :lastfm_url
    remove_column :artists, :listeners
    remove_column :artists, :play_count
    remove_column :artists, :image_url
    remove_column :artists, :summary
    remove_column :artists, :biography
    remove_column :artists, :similar_mbids
  end
end
