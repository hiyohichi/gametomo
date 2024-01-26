class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #ジャンルの関係
  has_many :user_genres
  has_many :genres, through: :user_genres

  has_many :comments, dependent: :destroy
  has_many :nices,dependent: :destroy
  #フォローした、されたの関係
  has_many :to_follow,  class_name:"Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :be_followed,class_name:"Relationship", foreign_key: "followed_id", dependent: :destroy
  #一覧画面で使う
  has_many :followings, through: :to_follow, source: :followed
  has_many :followers,  through: :be_followed, source: :follower
  #1週間のfollowersを取得
  has_many :week_followers, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  #DM機能
  has_many :messages, dependent: :destroy
  has_many :entries,  dependent: :destroy
  has_many :rooms,    through: :entries

  validates :name,length: {in:2..20}, uniqueness: true
  validates :introduction,length: {maximum:400}

  has_one_attached :profile_image

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width,height]).processed
  end

  #退会ユーザーへのログイン制限
  def active_for_authentication?
    super && (self.is_active == true)
  end

  #フォロー機能
  def follow(user_id)
    to_follow.create(followed_id: user_id)
  end
  #フォローを外す時の処理
  def unfollow(user_id)
    to_follow.find_by(followed_id: user_id).destroy
  end
  #フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  
  #ジャンルを区切る
  def platform()
    lis = []
    self.genres.each do |genre|
      lis.push(genre.pratform)
    end
    lis.join(" / ")
  end

  #ゲストログイン機能
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

end
