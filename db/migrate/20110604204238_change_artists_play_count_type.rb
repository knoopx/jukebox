class ChangeArtistsPlayCountType < ActiveRecord::Migration
  def self.up
    change_column :artists, :play_count, :integer, :default => 0
  end

  def self.down
    change_column :artists, :play_count, :string
  end
end
