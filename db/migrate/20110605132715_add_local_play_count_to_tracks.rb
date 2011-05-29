class AddLocalPlayCountToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :local_play_count, :integer, :default => 0
  end

  def self.down
    remove_column :tracks, :local_play_count
  end
end
