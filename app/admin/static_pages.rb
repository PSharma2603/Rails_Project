ActiveAdmin.register_page "StaticPages" do
  menu label: "Edit Static Pages"

  content do
    panel "Edit About and Contact Pages" do
      render partial: "admin/static_pages/form"
    end
  end

  page_action :update, method: :post do
    %w[About Contact].each do |title|
      page = StaticPage.find_by(title: title)
      page.update(content: params[title.downcase]) if page
    end
    redirect_to admin_static_pages_path, notice: "Pages updated!"
  end
end
