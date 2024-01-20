class Nice < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  #組み合わせが重複しないか
  validates :user_id,uniqueness: {scope: :comment_id}

end
