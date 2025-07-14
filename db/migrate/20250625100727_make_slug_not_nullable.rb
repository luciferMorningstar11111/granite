# Migration to make slug not nullable in tasks
# frozen_string_literal: true

class MakeSlugNotNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :slug, false
  end
end
