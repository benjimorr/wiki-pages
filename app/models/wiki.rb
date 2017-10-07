class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators

  #delegate :users, to: :collaborators

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }
  validates :user, presence: true
end
