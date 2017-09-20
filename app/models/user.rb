class User < ActiveRecord::Base
  has_many :wikis, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :email, length: { minimum: 3, maximum: 254 }
end
