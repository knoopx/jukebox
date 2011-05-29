class CreateArtistsReleases < ActiveRecord::Migration
  def self.up
    create_table :artists_releases, :id => false do |t|
      t.belongs_to :artist
      t.belongs_to :release
    end
  end

  def self.down
    drop_table :artists_releases
  end
end
