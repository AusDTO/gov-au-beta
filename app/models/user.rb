class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :requests

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def member_in_sections
    roles.map { |role| role.resource }.reject(&:nil?).uniq
  end
end
