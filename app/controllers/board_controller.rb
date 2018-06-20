class BoardController < ApplicationController
  def index
   @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end
  
  def create
    p1 = Post.new
    p1.title = params[:title]
    p1.contents = params[:contents]
    p1.save
    redirect_to "/board/#{p1.id}"  
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    p1 = Post.find(params[:id])
    p1.title = params[:title]
    p1.contents = params[:contents]
    p1.save
    redirect_to "/board/#{p1.id}" 
  end
  
  def destroy
    p1 = Post.find(params[:id])
    p1.destroy
    p1.save
    redirect_to "/boards"
  end
  
end
