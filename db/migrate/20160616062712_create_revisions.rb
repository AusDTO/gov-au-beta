class CreateRevisions < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    create_table :revisions, id: :uuid do |t|
      t.references :revisable, polymorphic: true
      t.jsonb :diffs
      t.timestamp :created_at
      t.timestamp :applied_at
    end
  end
end