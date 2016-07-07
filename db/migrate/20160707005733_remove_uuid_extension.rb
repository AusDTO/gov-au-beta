class RemoveUuidExtension < ActiveRecord::Migration[5.0]
  def up
    change_column_default :revisions, :id, nil
    disable_extension "uuid-ossp"
  end
end
