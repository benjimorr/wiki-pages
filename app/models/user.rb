class User < ActiveRecord::Base
  has_many :collaborators, dependent: :destroy
  has_many :wikis, through: :collaborators, dependent: :destroy

  delegate :wikis, to: :collaborators

  after_initialize { self.role ||= :standard }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :email, length: { minimum: 3, maximum: 254 }

  enum role: [:standard, :premium, :admin]
end
