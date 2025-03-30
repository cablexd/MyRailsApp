class ItemsController < ApplicationController
  def index
    @items = Item.all
    
    render :index
  end

  def new
    @item = Item.new name: "My Item"
  end

  def create
    @item = Item.new item_params

    if @item.save
      redirect_to @item
    else
      render :new, status: unprocessable_entity
    end
  end

  def show
    @item = Item.find params[:id]
  end

  def edit
    @item = Item.find params[:id]
  end

  def update
    @item = Item.find params[:id]

    if @item.update item_params
      redirect_to @item
    else
      render :edit, status: unprocessable_entity
    end
  end

  def update_complete
    @item = Item.find params[:id]
    @item.update(params.expect(item: [ :complete ]))

    respond_to do |format|
      format.turbo_stream do
        puts "test abc"
        render turbo_stream: turbo_stream.replace("item_#{@item.id}", content: '<p>This is a hardcoded paragraph.</p>')
      end
    end
  end

  def destroy
    @item = Item.find params[:id]
    @item.destroy
    redirect_to items_path
  end

  private
    def item_params
      params.expect item: %i[ name description complete ]
    end
end
