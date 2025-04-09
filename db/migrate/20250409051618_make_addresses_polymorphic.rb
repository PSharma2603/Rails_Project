class MakeAddressesPolymorphic < ActiveRecord::Migration[7.0]
  def change
    # Remove existing user_id column (if any)
    remove_column :addresses, :user_id, :integer if column_exists?(:addresses, :user_id)

    # Add polymorphic reference
    add_reference :addresses, :addressable, polymorphic: true, index: true
  end
end
