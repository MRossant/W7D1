class CatsController < ApplicationController
  before_action :require_log_in, only: [:update, :edit]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat[:user_id] = user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.select.joins(:owner).where(cats: {user_id: current_user.id}) #Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.select.joins(:owner).where(cats: {user_id: current_user.id}) #Cat.find(params[:id])
    redirect_to new_cat_url if @cat == nil
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
