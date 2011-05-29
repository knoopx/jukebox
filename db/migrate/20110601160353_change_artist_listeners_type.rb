class ChangeArtistListenersType < ActiveRecord::Migration
  def self.up
    change_column :artists, :listeners, :integer, :default => 0
  end

  def self.down
    change_column :artists, :listeners, :string
  end
end
