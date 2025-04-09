class RemoveProvinceStringFromAddresses < ActiveRecord::Migration[7.2]
  def change
    remove_column :addresses, :province, :string
  end
end
