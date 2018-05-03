class User < ApplicationRecord
  has_many :worktimes, dependent: :destroy
  attr_accessor :login
  validates :username, presence: :true, uniqueness: { case_sensitive: false }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]
         
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
    end
  end


  def last_worktime
    self.worktimes.where(end_time: nil).order(created_at: :desc).first
  end
end
