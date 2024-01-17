class CreateGameGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :game_genres do |t|
      t.integer :game_id
      t.integer :genre_id

      t.timestamps
    end
  end
end
