class Wiki < ActiveRecord::Base
  scope :case_insensitive_find_by_subdomain, lambda {|subdomain| where("lower(subdomain) = ?", subdomain.downcase) }

  mount_uploader :logo, WikiLogoUploader

  has_many :users, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :draft_pages
  accepts_nested_attributes_for :users

  validates_uniqueness_of :subdomain, case_sensitive: false
  validates_associated :users
  validates_format_of :subdomain, with: /\A\w+\z/, message: I18n.t("activerecord.errors.messages.subdomain_format")
  validates_exclusion_of :subdomain, in: %w(blog admin wikenso)

  def self.build_with_active_user(params)
    if params[:users_attributes]
      params[:users_attributes].each { |_,user_attributes| user_attributes[:type] = "ActiveUser" }
    end
    Wiki.new(params)
  end

  def save_with_seed_page
    transaction do
      save!
      seed_page = WelcomePage.latest
      pages.create!(title: seed_page.title, text: seed_page.text)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def create_pending_user(email)
    user = PendingUser.create_with_invitation(email: email, wiki_id: self.id)
    if user.errors.empty?
      UserMailer.invitation_mail(user, self).deliver
    end
    user
  end

  def name
    self[:name].present? ? self[:name] : subdomain
  end

  def self.demo_wiki
    Wiki.find_by_subdomain("demo")
  end

  def demo_wiki?
    self == Wiki.demo_wiki
  end
end
