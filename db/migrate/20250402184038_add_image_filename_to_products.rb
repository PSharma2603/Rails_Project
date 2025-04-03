class AddImageFilenameToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :image_filename, :string
  end
end
