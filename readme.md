## Day10.  검색, 외래키 



## 검색

- table의 id 값과 일치하는 이 컬럼은 인덱싱이 되어있기 때문에 검색 속도가 매우 빠르고 고유한 값을 가진다.

- table의 id 값으로 해결하지 못하는 경우는?

  - Table에 있는 다른 컬럼으로 검색할 경우에는 

  - find_by 의 특징: 1개만 검색된다는 점, 일치하는 값이 없는 경우 nil을 리턴함

- 추가적인 검색방법 : Model.where(컬럼명: value(검색어 값))

  - Ex. User.where(user_name: "123")
  - where의 특징: 검색 결과가 여러개, 결과값이 배열 형태이며 일치하는 값이 없는 경우 빈 배열이 나옴 (배열은 아님) 

- 포함

  - 텍스트가 특정 단어/문장을 포함하고 있는가?
  - Model.where("컬럼명 Like?", "%#(value)%")
  - Model.where("컬럼명 Like? "%#(value)%") 되기는 하지만 쓰면 안됨
    - SQL injection(해킹) 가능, 사용자가 마음대로 바꿔 사용할 수 있음
  - Full text Search 방식이 보다 효율적임



`?` 를 사용하면, True or False 값이 return으로 나올 수 있다는 것을 예상

`!(bang)` 내가 의도하지 않은 Action이 발생할 수 있는 action에 붙여주기

원형을 변경시키는 method에도 사용함 `.delete!`



### 1:n relation 구축 (1명의 유저 : 여러개의 글 작성)



1. 외래키 만들기 
   - `t.integer :user_id `를 *db/migrate/2018.._posts.rb* 에 추가
     - index 고유 값을 받아오기 위함

*models/user.rb*

```ruby
class User < ApplicationRecord
    has_many :posts
end
```

- 1명이 여러 개의 글을 작성할 수 있도록 설정  **'s'** 꼭 붙이기



models/post.rb

```ruby
class Post < ApplicationRecord
    belongs_to :user
end
```

- 포스트는 1명의 유저에 종속됨



*rails c 실행해서 db 확인하기*

```command
# User 테이블에서 데이터를 받기 위한 'u' 변수 만들기
2.3.4 :001 > u = User.new
 => #<User id: nil, user_name: nil, password: nil, ip_address: nil, created_at: nil, updated_at: nil> 
2.3.4 :002 > u.user_name = "haha"
 => "haha" 
2.3.4 :003 > u.password = "1234"
 => "1234" 
2.3.4 :004 > u.save
   (0.2ms)  begin transaction
  SQL (0.6ms)  INSERT INTO "users" ("user_name", "password", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["user_name", "haha"], ["password", "1234"], ["created_at", "2018-06-21 05:12:10.102800"], ["updated_at", "2018-06-21 05:12:10.102800"]]
   (16.5ms)  commit transaction
 => true 
 
# Post 테이블에서 데이터를 받기 위한 'p' 변수 만들기
2.3.4 :005 > p = Post.new
 => #<Post id: nil, title: nil, contents: nil, user_id: nil, created_at: nil, updated_at: nil> 
2.3.4 :006 > p.title = "simple"
 => "simple" 
2.3.4 :007 > p.contents = "relation"
 => "relation" 
2.3.4 :010 > p.save
   (0.2ms)  begin transaction
  User Load (0.4ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  SQL (0.5ms)  INSERT INTO "posts" ("title", "contents", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["title", "simple"], ["contents", "relation"], ["user_id", 1], ["created_at", "2018-06-21 05:13:51.503199"], ["updated_at", "2018-06-21 05:13:51.503199"]]
   (12.5ms)  commit transaction
 => true 

# u에 해당하는 사람이 적은 posts 볼 수 있음
2.3.4 :011 > u.posts
  Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 1]]
 => #<ActiveRecord::Associations::CollectionProxy [#<Post id: 1, title: "simple", contents: "relation", user_id: 1, created_at: "2018-06-21 05:13:51", updated_at: "2018-06-21 05:13:51">]> 
 
# p에 해당하는 포트스의 user 작성자를 볼 수 있음
2.3.4 :013 > p.user
 => #<User id: 1, user_name: "haha", password: "1234", ip_address: nil, created_at: "2018-06-21 05:12:10", updated_at: "2018-06-21 05:12:10"> 
```



2. controller 추가 및 수정하기

*app/application_controller.rb*

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_signed_in?
  
  # 현재 로그인 된 상태니?
  # 로그인 되어 있지 않으면, 로그인하는 화면으로 이동 시켜줘
    # '?' 가 붙으면 리턴값으로 True, False를 출력할 것을 예상할 수 있음
  def user_signed_in?
      session[:current_user].present?
  end
  
  # 로그인 되어 있지 않으면 로그인하는 페이지로 이동시켜주기
  def authenticate_user!
    # false라면,
    unless user_signed_in?
        redirect_to '/sign_in'
    end
  end
  
  # 현재 로그인 된 사람은 누구니?
  def current_user
      # 현재 로그인은 돼있니?
      	# True라면,
        if user_signed_in?
          # session[:current_user]는 user_controller에서 정의했음
          @current_user = User.find(session[:current_user])
        end
  end
end
```

- helper_method 

  : 원래 view에서는 controller에 정의된 method를 사용할 수 없지만, 

    view에서 일부 메소드 사용이 가능토록 하기 위해 `helper_method`사용



*app/board_controller.rb*

```ruby
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
  
  # 반복되는 부분을 메소드로 생성
  def set_post
    @post = Post.find(params[:id])
  end
end
```

- before_action :set_post, only: [:show, :edit, :update, :destroy]

  : show, edit, update, destroy의 메소드에만 시작하기 전 무조건 `set_post`를  실행

- before_action :authenticate_user!, except: [:index, :show]

  :  index, show 메소드를 제외하고 모든 메소드에, 시작하기 전 `authenticate_user!`을 먼저 실행도록 설정함





> 값이 비어있는지 확인하기 위해서는..
>
> find_by_는 nil? 
>
> where은 .empty? 리턴값이 배열일 때는 .empty나 .length로 물어봐야 함