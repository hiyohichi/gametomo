class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :genre_id, null: false
      t.string  :title,    null: false
      t.text    :introduction

      t.timestamps
    end
  end
end
