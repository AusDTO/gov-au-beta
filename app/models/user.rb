class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :requests

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def member_of_sections
    # Admins are implicit members of all sections
    if has_role? :admin
      Section.where.not(name: 'news')
    else
      roles.map { |role| role.resource }.reject(&:nil?).uniq
    end
  end

  def is_member?(section)
    member_of_sections.include? section
  end
end
