class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many   :naces,dependent: :destroy
  #nicesテーブルを介してUserモデルのコレクションを取得する
  has_many :niced_users, through: :nices, source: :user

  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
