class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:name,:uid,:provider
  # attr_accessible :title, :body
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(  name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
