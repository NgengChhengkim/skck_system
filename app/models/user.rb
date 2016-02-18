class User < ActiveRecord::Base

  belongs_to :company

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
