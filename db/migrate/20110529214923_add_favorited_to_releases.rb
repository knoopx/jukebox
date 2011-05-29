class AddFavoritedToReleases < ActiveRecord::Migration
  def self.up
    add_column :releases, :favorited, :boolean, :default => false
  end

  def self.down
    remove_column :releases, :favorited
  end
end
