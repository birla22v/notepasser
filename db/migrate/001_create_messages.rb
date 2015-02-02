class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text: message
      t.string: sender_login
      t.string: receiver_login
      t.integer: message_id
    end
  end

  def self.down
    drop_table :messages
  end
end
