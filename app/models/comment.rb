# frozen_string_literal: true

class Comment < ApplicationRecord
  # Constants
  MAX_CONTENT_LENGTH = 511

  # Associations
  belongs_to :task, counter_cache: true
  belongs_to :user

  # Validations
  validates :content, presence: true, length: { maximum: MAX_CONTENT_LENGTH }
end
