class CreateDraftSelections < ActiveRecord::Migration
  def change
    create_table :draft_selections do |t|
      t.string  :name
      t.integer :year
      t.integer :round
      t.integer :pick
      t.integer :overall_selection
      t.string  :nfl_team
      t.string  :college_team
      t.string  :position
      t.integer :player_id  # foreign key

      t.timestamps
    end
  end
end
