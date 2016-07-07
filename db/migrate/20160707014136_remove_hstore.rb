class RemoveHstore < ActiveRecord::Migration[5.0]
  def up
    add_column :nodes, :content_jsonb, :jsonb
    execute <<-SQL
      update nodes set content_jsonb = cast(content as jsonb);
    SQL
    remove_column :nodes, :content
    rename_column :nodes, :content_jsonb, :content
    disable_extension "hstore"
  end
end
