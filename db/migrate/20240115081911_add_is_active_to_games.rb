class AddIsActiveToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :is_active, :boolean, default: true, null: fa
  end
end
