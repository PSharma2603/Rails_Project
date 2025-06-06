class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :orders
  belongs_to :province, optional: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
