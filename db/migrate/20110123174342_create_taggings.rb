class CreateTaggings < ActiveRecord::Migration
  def self.up
    rename_table :artists_genres, :taggings
    add_column :taggings, :id, :integer, :primary_key => true
  end

  def self.down
    remove_column :id
    rename_table :taggings, :artists_genres
  end
end
