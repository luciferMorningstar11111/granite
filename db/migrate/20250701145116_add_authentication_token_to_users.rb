# Migration to add authentication_token to users
# frozen_string_literal: true

class AddAuthenticationTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :authentication_token, :string
  end
end
