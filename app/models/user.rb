class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  has_many :requests

  validates :email, email_domain_whitelist: true

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

  def pending_request_for(section)
    requests.find_by(section: section, state: 'requested')
  end

  def pending_request_for?(section)
    pending_request_for(section).present?
  end

  # FIXME: Rollify uses polymophism which doesn't work properly
  # with STI on Section. Suggest using a collaborator model on sections instead
  def collaborator_on?(section)
    roles.exists?(resource_id: section)
  end
end
