class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.belongs_to :uploader, class: User

      t.attachment :asset_file
      t.string :asset_file_content_type
      t.string :asset_file_fingerprint

      t.timestamps
    end
  end
end
