module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope -> { where("deleted_at IS NULL") }
  end

  def soft_delete
    update_attributes(deleted_at: Time.now)
  end
end