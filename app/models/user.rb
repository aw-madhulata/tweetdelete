class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets

  def self.save_tweets 
    User.all.find_in_batches do |users|
      users.each do |user|
        # Find tweets from the user 
        x_client_service = XClientService.new
        tweets = x_client_service.list_tweets(user.x_user_id)
        tweets["data"].each do |tweet| 
          Tweet.create(post_id: tweet["id"], user_id: user.id)
        end 
      end 
    end 
  end 
end
