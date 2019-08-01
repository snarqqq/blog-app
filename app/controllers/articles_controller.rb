class ArticlesController < ApplicationController

  before_action :move_to_index, except: :index
  before_action :set_article, only: [:edit, :show, :destroy, :update]

  def index
    @articles = Article.includes(:user).page(params[:page]).per(5).order("created_at DESC")
  end

  def new
    return
  end

  def create
    Article.create(article_params)
  end

  def destroy
    if @article.user_id == current_user.id
      @article.destroy
    end
  end

  def edit
    @article = Article.find(params[:id])

  end

  def update
    if @article.user_id == current_user.id
      @article.update(article_params)
    end
  end

  def show
    @comments = @article.comments.includes(:user)
  end

  private
  def article_params
    params.permit(:title, :image, :text).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def set_article
    @article = Article.find(params[:id])
  end

end
