class CafeController < ApplicationController
    before_action :set_cafe, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    
    
    def index
        @caves = Cafe.all
    end
    
    def show
    end
    
    def new
    end
    
    def create
        cafe = Cafe.new
        cafe.title = params[:title]
        cafe.description = params[:description]
        cafe.save
        
        redirect_to "/cafe/#{cafe.id}"
    end
    
    def edit
    end
    
    def update
        @cafe.title = params[:title]
        @cafe.description = params[:description]
        @cafe.save
        
        redirect_to "/cafe/#{@cafe.id}"
    end 
    
    
    def destroy
        @cafe.destroy
        @cafe.save
        
        redirect_to "/caves"
    end
    
    def set_cafe
        @cafe = Cafe.find(params[:id])
    end
    
end
