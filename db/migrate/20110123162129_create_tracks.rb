class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :number
      t.string :title
      t.string :sample_rate
      t.string :bitrate
      t.string :channels
      t.string :length
      t.string :filename
      t.belongs_to :release
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
