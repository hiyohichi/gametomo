class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many   :nices,dependent: :destroy
  #nicesテーブルを介してUserモデルのコレクションを取得する
  has_many :niced_users, through: :nices, source: :user
  #空でないか
  validates :comment,presence:true
  
  def niced_by?(user)
    nices.exists?(user_id: user.id)
  end
end
