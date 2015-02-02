require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "pry"

Camping.goes :Notepasser

module Notepasser
end

module Notepasser::Models
  class User < ActiveRecord::Base
    validates :user_id, presence: true, uniqueness: true
    validates :password, presence: true
    has_many :messages
  end

  class Message < ActiveRecord::Base
    validates :message, presence: true
    validates :sender_login, presence: true, uniqueness: true
    validates :receiver_login, presence: true, uniqueness: true
    validates :message_id, uniqueness: true
    belongs_to :user
  end
end

module Notepasser::Controllers
  class UserController < R '/user'
    def get
      page = @input['page']||1
      start = (page-1)*20
      finish = (page)*20
      Notepasser::Models::User.where():id => [start .. finish]).to_json
    end

    def post
      new_user = Notepasser::Models::User.create(@input)
      [:user_id, :password].each do |u|
        new_user[u] = @input[u]
      end
      @status = 201
      {:message => "User #{new_user.id} created",
      :code => 201,
      :post => new_user}.to_json
    end
  end

  class UserId < R '/user/(\d+)'
    def get(id)
      user = Notepasser::Models::User.find(id)
      user.to_json
    rescue ActiveRecord::RecordNotFound
      @status = 404
      "404 - User not found"
    end

    def delete(id)
      user = Notepasser::Models::User.find(id)
      user.destroy
      @status = 204
    end
  end

  class MessageController <R '/messages'
    def get
      page = @input['page']||1
      start = (page-1)*20
      finish = (page)*20
      Notepasser::Models::Message.where():id => [start .. finish]).to_json
    end

    def post
      new_message = Notepasser::Models::Message.create(@input)
      [:message, :sender_login, :receiver_login, :message_id].each do |m|
        new_message[m] = @input[m]
      end
      @status = 201
      {:message => "Message #{new_message.id} created",
      :code => 201,
      :post => new_user}.to_json
    end
  end

  class MessageId < R '/messages/(\d+)'
    def get(id)
      msg = Notepasser::Models::Message.find(id)
      msg.to_json
    rescue ActiveRecord::RecordNotFound
      @status = 404
      "404 - Message not found"
    end

    def delete(id)
      msg = Notepasser::Models::Message.find(id)
      msg.destroy
      @status = 204
    end
end
