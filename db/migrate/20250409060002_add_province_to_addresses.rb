class AddProvinceToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_reference :addresses, :province, null: false, foreign_key: true
  end
end
