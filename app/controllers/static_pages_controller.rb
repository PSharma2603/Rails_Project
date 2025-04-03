class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by(title: params[:title])
    if @page
      render :show
    else
      redirect_to root_path, alert: "Page not found"
    end
  end
end
