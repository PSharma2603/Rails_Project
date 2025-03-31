ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image

  includes :category

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column "Image" do |product|
      if product.image.attached?
        image_tag url_for(product.image.variant(resize_to_limit: [100, 100])), height: 50
      end
    end
    actions
  end

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category
      f.input :image, as: :file
    end
    f.actions
  end

  filter :name
  filter :description
  filter :price
  filter :stock_quantity
  filter :category
end
