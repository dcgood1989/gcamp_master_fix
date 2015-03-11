class Membershipss < ActiveRecord::Migration
  def change
    add_column :memberships, :roles, :integer
  end
end
