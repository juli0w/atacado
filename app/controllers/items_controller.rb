class ItemsController < ApplicationController
  before_filter :set_item, only: [:edit, :update]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    if params[:keyword].present?
      @items = Item.search(params[:keyword]).page(params[:page]).order(:name)
    else
      @items = Item.all.page(params[:page]).order(:name)
    end

    if params[:noimage]
      @items = @items.where(image: nil)
    end
  end

  def print
    if params[:keyword].present?
      @items = Item.search(params[:keyword])
    else
      @items = Item.all.page(params[:page]).per(250)
    end

    render layout: nil
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = "Salvo com sucesso!"
      redirect_to items_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to items_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :remove_image, :name, :price)
  end
end
