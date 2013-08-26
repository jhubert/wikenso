class Wiki < ActiveRecord::Base
  scope :case_insensitive_find_by_subdomain, lambda {|subdomain| where("lower(subdomain) = ?", subdomain.downcase) }

  has_many :users
  has_many :pages
  accepts_nested_attributes_for :users

  validates_uniqueness_of :subdomain, case_sensitive: false
  validates_associated :users
  validates_format_of :subdomain, with: /\A\w+\z/, message: I18n.t("activerecord.errors.messages.subdomain_format")

  def create_pending_user(email)
    user = PendingUser.create(email: email, wiki_id: self.id)
    if user.errors.empty?
      UserMailer.invitation_mail(user, self).deliver
    end
    user
  end
end
