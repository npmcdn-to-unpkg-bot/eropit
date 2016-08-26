class CategoriesController < ApplicationController
  skip_before_action :basic_auth, only: [:show]

  def create
    category = Category.new category_params
    redirect_to admin_path if category.save
  end

  def show
    #code
  end

  private
    def category_params
      params.require(:category).permit(:title)
    end
end
