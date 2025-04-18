class ItemsController < ApplicationController
  def index
    @items = params[:show_complete].present? ? Item.all : Item.where(complete: true)
    # @items = Item.all
    puts @items

    render :index
  end

  def test
    render html: "<turbo-frame id='test'><p>This is a test element</p></turbo-frame>".html_safe
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

    # this works because the request is coming from within a turbo frame, and so it gets replaced
    render partial: "items/item_status", locals: { item: @item }, content_type: "text/html" # force content type because sometimes server sends it back as turbo stream which makes it get appended after the body tag

    # to use other parts of the dom, this would have to be used (items-list is the ID of the element being used)
    # respond_to do |format|
    #   format.turbo_stream do
    #     render turbo_stream: turbo_stream.append("items-list", partial: "items/item", locals: { item: @item })
    #   end
    # end
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
