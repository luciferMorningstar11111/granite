# frozen_string_literal: true

class Task < ApplicationRecord
  after_create :log_task_details
  # Constants
  MAX_TITLE_LENGTH = 125
  VALID_TITLE_REGEX = /\A.*[a-zA-Z0-9].*\z/i
  RESTRICTED_ATTRIBUTES = %i[title task_owner_id assigned_user_id].freeze

  # Enums
  enum :status, { unstarred: 'unstarred', starred: 'starred' }, default: :unstarred
  enum :progress, { pending: 'pending', completed: 'completed' }, default: :pending

  # Scopes
  scope :by_priority, -> { in_order_of(:status, %w[starred unstarred]).order('updated_at DESC') }

  # Associations
  belongs_to :assigned_user, foreign_key: 'assigned_user_id', class_name: 'User'
  belongs_to :task_owner, foreign_key: 'task_owner_id', class_name: 'User'
  has_many :comments, dependent: :destroy

  # Validations
  validates :title,
            presence: true,
            length: { maximum: MAX_TITLE_LENGTH },
            format: { with: VALID_TITLE_REGEX }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  # Callbacks
  before_create :set_slug

  private

  def self.of_status(progress)
    if progress == :pending
      pending.by_priority
    else
      completed.by_priority
    end
  end

  def set_slug
    title_slug = title.parameterize
    regex_pattern = "slug #{Constants::DB_REGEX_OPERATOR} ?"
    latest_task_slug = Task.where(
      regex_pattern,
      "^#{title_slug}$|^#{title_slug}-[0-9]+$"
    ).order('LENGTH(slug) DESC', slug: :desc).first&.slug

    slug_count = 0
    if latest_task_slug.present?
      slug_count = latest_task_slug.split('-').last.to_i
      slug_count = 1 if slug_count.zero?
    end

    self.slug = slug_count.positive? ? "#{title_slug}-#{slug_count + 1}" : title_slug
  end

  def slug_not_changed
    return unless will_save_change_to_slug? && persisted?

    errors.add(:slug, I18n.t('task.slug.immutable'))
  end

  def set_title
    self.title = 'Pay electricity bill'
  end

  def change_title
    self.title = 'Pay electricity & TV bill'
  end

  def log_task_details
    TaskLoggerJob.perform_async(self.id)
  end
end
