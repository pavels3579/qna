class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions, foreign_key: "author_id", dependent: :destroy
  has_many :answers, foreign_key: "author_id", dependent: :destroy
  has_many :best_answer_awards, dependent: :delete_all

  has_many :votes, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def its_author?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_verified?
    email && !email.include?('tempusermail.com')
  end

end
