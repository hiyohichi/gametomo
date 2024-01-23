class User::MessagesController < ApplicationController
  before_action :authenticate_user!
  # showアクションにおいて、関連のないユーザーをブロックする
  before_action :block_non_related_users, only: [:show]

  def show
    # チャット相手のユーザーを取得
    @user = User.find(params[:id])
    # 現在のユーザーが参加しているチャットルームの一覧を取得
    rooms = current_user.entries.pluck(:room_id)
    # 相手ユーザーとの共有チャットルームが存在するか確認
    entry = Entry.find_by(user_id: @user.id, room_id: rooms)
    unless entry.nil?
      # 共有チャットルームが存在する場合、そのチャットルームを表示
      @room = entry.room
    else
      # 共有チャットルームが存在しない場合、新しいチャットルームを作成
      @room = Room.new
      @room.user_id = current_user.id
      @room.save

      # チャットルームに現在のユーザーと相手ユーザーを追加
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    end

    # チャットルームに関連付けられたメッセージを取得
    @messages = @room.messages

    # 新しいメッセージを作成するための空のChatオブジェクトを生成
    @message = Message.new(room_id: @room.id)
  end

  # チャットメッセージの送信
  def create
    # フォームから送信されたメッセージを取得し、現在のユーザーに関連付けて保存
    @message = current_user.messages.new(message_params)
    # バリデーションに合格しない場合はエラーを表示
    render :validate unless @message.save
  end

  # チャットメッセージの削除
  def destroy
    # ログイン中のユーザーに関連するチャットメッセージを削除
    @message = current_user.messages.find(params[:id])
    @message.destroy
  end

  private

  # フォームから送信されたパラメータを安全に取得
  def message_params
    params.require(:message).permit(:message, :room_id)
  end

  # 関連のないユーザーをブロックする
  def block_non_related_users
    # チャット相手のユーザーを取得
    user = User.find(params[:id])

    # ユーザーがお互いにフォローしているか確認し、していない場合はリダイレクト
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to users_path
    end
  end

end
