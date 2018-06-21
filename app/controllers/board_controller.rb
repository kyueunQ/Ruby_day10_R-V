class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :set_post, except: [:new, :index, :create]
  # 로그인 된 상태에서만 접속할 수 있는 페이지는?
  # index, show만 로그인 하지 않은 상태에서 볼 수 있고,
  # 나머지는 반드시 로그인이 필요하도록 제한
  before_action :authenticate_user!, except: [:index, :show]
  
  
  def index
   @posts = Post.all
   current_user
  end

  def show
  end

  def new
  end
  
  def create
    p1 = Post.new
    p1.title = params[:title]
    p1.contents = params[:contents]
    p1.user_id = current_user.id
    p1.save
    # post를 등록할 때 이 글을 작성한 사람은 현재 로그인이 되어 있는 유저이다.
    
    redirect_to "/board/#{p1.id}"  
  end

  def edit
    set_post
    puts @post
  end
  
  def update
    @post.title = params[:title]
    @post.contents = params[:contents]
    @post.save
    redirect_to "/board/#{p1.id}" 
  end
  
  def destroy
    @post.destroy
    @post.save
    redirect_to "/boards"
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
  
end
