class ChangeReleasesPlayCountType < ActiveRecord::Migration
  def self.up
    change_column :releases, :play_count, :integer, :default => 0
  end

  def self.down
    change_column :releases, :play_count, :string
  end
end
