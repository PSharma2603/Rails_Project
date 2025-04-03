ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image_filename
  include Rails.application.routes.url_helpers
  includes :category

  # 👇 Index page with image preview
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column "Image" do |product|
      if product.image_filename.present?
        image_tag("products/#{product.image_filename}", size: "100x70")
      else
        content_tag(:span, "No image")
      end
    end
    actions
  end

  # 👇 Show page with full image
  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :image_filename
      row "Image" do |product|
        if product.image_filename.present?
          image_tag("products/#{product.image_filename}", size: "300x200")
        else
          content_tag(:span, "No image")
        end
      end
    end
  end

  # 👇 Form with dropdown for image filenames
  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category

      # Only display image filenames in /products folder
      image_files = Dir.glob(Rails.root.join("app/assets/images/products/*")).map { |path| File.basename(path) }
      f.input :image_filename, as: :select, collection: image_files, include_blank: "Select image"
    end
    f.actions
  end

  # Filters
  filter :name
  filter :description
  filter :price
  filter :stock_quantity
  filter :category
end
