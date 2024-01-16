class Genre < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :users, dependent: :destroy
end
