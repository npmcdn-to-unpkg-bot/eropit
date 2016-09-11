class TagsController < ApplicationController
  def index
    @title = 'タグ管理'
    @tags = ActsAsTaggableOn::Tag.all.page(params[:page])
  end

  def edit
    @title = 'タグ編集'
    @tag = ActsAsTaggableOn::Tag.find_by(id: params[:id])
  end

  def update
    tag = ActsAsTaggableOn::Tag.find_by(id: params[:id])
    tag.update_attributes tag_params

    redirect_to tags_path
  end

  private
    def tag_params
      params.require(:tag).permit(:name, :mean, :suf_words, :pre_words)
    end
end
