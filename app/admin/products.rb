ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image_filename, :image
  include Rails.application.routes.url_helpers
  includes :category

  # Index Page
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column "Image" do |product|
      if product.image.attached?
        image_tag(url_for(product.image), size: "100x70")
      elsif product.image_filename.present?
        image_tag("products/#{product.image_filename}", size: "100x70")
      else
        content_tag(:span, "No image")
      end
    end
    actions
  end

  # Show Page
  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :image_filename
      row "Image" do |product|
        if product.image.attached?
          image_tag(url_for(product.image), size: "300x200")
        elsif product.image_filename.present?
          image_tag("products/#{product.image_filename}", size: "300x200")
        else
          content_tag(:span, "No image")
        end
      end
    end
  end

  # Form Page
  form multipart: true do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category

      # Dropdown for existing image filenames (preserved)
      image_files = Dir.glob(Rails.root.join("app/assets/images/products/*")).map { |path| File.basename(path) }
      f.input :image_filename, as: :select, collection: image_files, include_blank: "Select image"

      # New: File upload field for ActiveStorage
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(url_for(f.object.image), size: "100x70") : content_tag(:span, "No image uploaded")
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
