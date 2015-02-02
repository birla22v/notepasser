require 'httparty'

class Client
  include HTTParty
  base_uri 'http://192.168.0.103:3301'

  def create_user
    new_user = Notepasser::Models::User.create(@input)
    [:user_id, :password].each do |u|
      new_user[u] = @input[u]
    end
  end

  def send_message(sender_login, receiver_login)
    puts "Enter message: "
    msg = gets.chomp
    opts = {:sender_login => sender_login, :receiver_login => receiver_login,
      :message => msg}
    resp = self.class.post("/message", :body => opts)

  end

  def get_messages
    resp = self.class.get("/message")
    msg = JSON.parse(resp.body)
    puts msg
  end

  def list_users
    resp = self.class.get("/users")
    users = JSON.parse(resp.body)
    users.each do |user|
      puts user
    end
  end

  def get_user(user_id)
    result = self.class.get("/users/#{user_id}")
    JSON.parse(result.body)
  end
end
