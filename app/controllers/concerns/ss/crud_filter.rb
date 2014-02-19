# coding: utf-8
module SS::CrudFilter
  extend ActiveSupport::Concern
  
  included do
    cattr_accessor :model_class
    before_action :set_model
    before_action :set_item, only: [:show, :edit, :update, :delete, :destroy]
    
    menu_view "ss/crud/menu"
  end
  
  module ClassMethods
    
    def model(cls)
      self.model_class = cls if cls
    end
  end
  
  private
    def set_model
      @model = self.class.model_class
    end
    
    def set_item
      @item = @model.find(params[:id])
    end
    
    def set_params(keys = [])
      keys = [keys] if keys.class != Array
      permitted = params.require(:item).permit(@model.permitted_fields + keys)
    end
    
  public
    def index
      @items = @model.all.sort(_id: -1)
      render_crud
    end
    
    def show
      render_crud
    end
    
    def new
      @item = @model.new
      render_crud
    end
    
    def edit
      render_crud
    end
    
    def delete
      render_crud
    end
    
    def create
      @item = @model.new(set_params)
      base_create
    end
    
    def update
      @item.attributes = set_params
      base_update
    end
    
    def destroy
      @item.destroy
      base_destroy
    end
    
  private
    def render_crud(action = params[:action])
      #@head = "#{params[:controller]}/head" if ::File.exists?("#{Rails.root}/app/views/#{params[:controller]}/_head.html.erb")
      
      if ::File.exists?("#{Rails.root}/app/views/#{params[:controller]}/#{action}.html.erb")
        render "#{Rails.root}/app/views/#{params[:controller]}/#{action}.html.erb"
      else
        render "#{Rails.root}/app/views/ss/crud/#{action}"
      end
    end
    
    def base_create
      respond_to do |format|
        if @item.save
          format.html { redirect_to({ action: :show, id: @item }, notice: "Created.") }
          format.json { render action: 'show', status: :created, location: @item }
        else
          format.html { render_crud :new }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def base_update
      respond_to do |format|
        if @item.update
          format.html { redirect_to({ action: :show }, notice: "Updated.") }
          format.json { head :no_content }
        else
          format.html { render_crud :edit }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def base_destroy
      respond_to do |format|
        format.html { redirect_to({ action: :index }, notice: "Destroyed.") }
        format.json { head :no_content }
      end
    end
end
