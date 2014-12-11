class Event < ActiveRecord::Base
  validates :title, presence: true
  validates :uuid, presence: true, uniqueness: true

  before_validation :ensure_uuid

  default_scope { where(deleted_at: nil) }

  self.primary_key = 'uuid'

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def destroy
    self.update_attributes(deleted_at: DateTime.current)
  end

  def delete
    destroy
  end

  def deleted?
    self.deleted_at.present?
  end
end
