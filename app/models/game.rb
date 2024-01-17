class Game < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :game_genres
  has_many :genres, through: :game_genres
  
  validates :title,presence: true
  validates :introduction,presence: true, length:{maximum:400}
  
  has_one_attached :game_image
  
  def get_game_image(width,height)
    unless game_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      game_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    game_image.variant(resize_to_limit: [width,height]).processed
  end
end
