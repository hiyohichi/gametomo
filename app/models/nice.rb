class Nice < ApplicationRecord
  belongs_to :user
  belongs_to :game
  #組み合わせが重複しないか
  validates :user_id,uniqueness: {scope: :game_id}

end
