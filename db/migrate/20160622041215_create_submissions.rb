class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.uuid :revision_id, null: false
      t.integer :submitter_id, null: false
      t.integer :reviewer_id, null: true
      t.text :summary
      t.timestamp :submitted_at, null: true
      t.timestamp :reviewed_at, null: true
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
  end
end
