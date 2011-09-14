class RemoveNameFromDraftSelection < ActiveRecord::Migration
  def up
    remove_column :draft_selections, :name
  end

  def down
    add_column :draft_selections, :name, :string
  end
end
