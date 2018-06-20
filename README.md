## Day 09 . boostrap 적용 + Session를 활용한 로그인

*[kyueunQ.github.io](https://github.com/kyueunQ/kyueunQ.github.io)* repository 내용

### 1. CSS 파일 수정

- 선택도구로 해당 부분을 찍고, 오른쪽의 `CSS Style`부분 보기
- 해당 속성이 어떤 파일의 몇 번째 줄에 있는지 명시되어 있음
- 해당 부분으로 찾아가 원하는 이미지로 변경하기



### 2. HTML 파일 수정

- 선택 도구로 해당 부분을 선택한 후  그대로 복사하기
- index.html 파일에서 F5를 통해 해당 코드가 나오는 위치를 찾아서 수정



### 3. icon 변경하기

https://fontawesome.com/v4.7.0/icons/

- 선택 도구로 해당 부분을 선택한 후 그대로 복사하기
- index.html 파일과 동일하게 해당 부분을 검색하여 수정해주기



### 4. 사진 속의 사진

- 700 x 467 사이즈로 맞춰서 올려야함 / 400 x 300 사이즈 

  (혹은 비율 맞춰주기)





### 오전 퀴즈

- MVC 패턴을 단어로 정의하기 
  - 값을 검증하기 위함 (사용자가 넘긴 parameter값이 맞는가)
- Rails 지향점: fat model skinny controller



### 간단과제

- BoardController 는 완성했음
- User 모델과 UserController CRUD
  - coulmns:id, password, ip_address
  - show에서는 id와 ip_address만 보이게 (pw제외)
  - delete는 없음
  - /user/new -> /sign_up
- Cafe 모델과 CafeController CRUD
  - columns; title, description
- View 까지 완성하기



1. Model 만들기 `$ rails g model user user_name, password, ip_address`

2. *config/routes.rb*

   ```ruby
     get '/users' => 'user#index'
     get '/user/:id' => 'user#show'
     get '/sign_up' => 'user#new'
     get '/sign_in' => 'user#sign_in'
     get '/logout' => 'user#logout'
     post '/sign_in' => 'user#login'
     post '/users' => 'user#create'
   
     get '/user/:id/edit' => 'user#edit'
     put '/user/:id' => 'user#update'
     patch '/user/:id' => 'user#update'
   
   ```

   

3. Controller 만들기 `$ rails g controller user index, new, show, edit`

```ruby
class UserController < ApplicationController
  def index
    @users = User.all
    # if session[:current_user] : false라면 출력되는 것이 없음
    @current_user = User.find(session[:current_user]) if session[:current_user]
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end
  
  def create
    user = User.new
    user.user_name = params[:user_name]
    user.password = params[:password]
    user.ip_address = request.ip
    user.save
    
    redirect_to "/user/#{user.id}"
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    user = User.find(params[:id])
    user.password = params[:password]
    user.save
    
    redirect_to "/user/#{user.id}"
  end
  
  def sign_in
    # 로그인 되어있는지 확인하고
    # 로그인 되어있으면 원래 페이지로 돌아가기
  end
  
  def login
    # 유저가 입력한 아이디와 패스워드를 바탕으로
    # 실제로 로그인이 이뤄지는 곳
    id = params[:user_name]
    pw = params[:password]
    # 유저가 입력한 user_name을 기반으로 index 값을 찾음
    user = User.find_by_user_name(id)
    
    # user.nil? : 유저가 비어있나요? = 접속한 유저가 없음  
    if !user.nil? and user.password.eql?(pw)
      # 해당 user_id로 가입한 유저가 있고, 패드워드도 일치하는 경우
      session[:current_user] = user.id
      flash[:success] = "로그인에 성공했습니다."
      redirect_to "/users"
      
    else
      # 가입한 유저 아이디가 없거나, 패스워드가 틀린 경우
      flash[:error] = "가입된 유저가 아니거나, 비밀번호가 틀립니다."
      redirect_to "/sign_in"
    end
  
  end
  
  def logout
    session.delete(:current_user)
    flash[:success] = "로그아웃 성공"
    redirect_to "/users"
  end
  
end
```

- User.find(params[:id]) : id라는 고유 값의 경우 .find 사용
- User.find_by_user_name(id) : column으로 자료를 검색할 경우 .find_by_user_name 사용



4. views 구현

*views/index.html.erb*

```erb
<% if @current_user.nil? %>
    <!-- 로그인이 되지 않은 상태 -->
    <%= link_to "로그인", '/sign_in' %>

<% else %>
    <!-- 로그인 된 상태 -->
    <p>현재 로그인된 유저: <%= @current_user.user_name %></p>
    <%= link_to "로그아웃", "/logout" %>
<% end %>
<ul>
    <% @users.each do |user| %>
        <li><%= link_to user.user_name, "/user/#{user.id}" %></li>
    <% end %>
    <br/>
    <%= link_to "회원가입", "/sign_up" %>
</ul>
```



*views/edit.html.erb*

```erb
<%= form_tag("/user/#{@user.id}", method: "PATCH") do %>
    ID: <%= text_field_tag(:user_name, @user.user_name, readonly:true) %> <br/>
    PW: <%= password_field_tag(:password) %>
    <%= submit_tag("수정") %>

<% end %>
```

- <form action="/user/7" accept-charset="UTF-8" method="post">  .... 

  <input type="hidden" name="_method" value="patch">

  : '수정' 을 클릭했을 때 개발자 도구를 통해서 보니, view helper의 폼 태그의 경우 POST 형식을 default로 우선 실행해준후, PATCH 형식으로 변환해주는 것을 볼 수 있음



*views/*show.html.erb

```erb
<div>
<h2><%=@user.user_name%></h2>
<hr/>
<p><%= @user.ip_address %></p>
<%= link_to "수정", "/user/#{@user.id}/edit" %>
</div>
```



views/new.html.erb

```erb
<h1>회원가입</h1>
<%= form_tag("/users") do %>
    ID: <%= text_field_tag(:user_name) %> <br/>
    PW: <%= password_field_tag(:password) %>
    <%= submit_tag("가입") %>
<% end %>
```



views/sign_in.html.erb

```erb
<h1>로그인</h1>
<%= form_tag do %>
    <%= text_field_tag(:user_name) %>
    <%= password_field_tag(:password) %>
    <%= submit_tag("로그인") %>
<% end %>
```



5. views 전체에 공통적으로 적용할 것 적기

```erb
...

<body>
  <% flash.each do |k, v| %>
    <p><%= v %></p>
  <% end %>
    <%= yield %>
  </body>
</html>
```







> ### Session
>
> - session은 server에 저장됨
>   - cookie는 browser에 저장
>   - session id(session  주소)가 cookie에 저장됨
>   - session은 서버에 접속하는 사람마다 각기 생성됨







> 오늘의 error
>
> - <%= form_tag("/user/#{@user.id}", **method: "patch"**) **do** %>
>   - method도 괄호 안에 넣기
>   - `do`잊지말고 적기
> - 오늘틔 팁
>   - `put` 다 지우고 다시 등록, `fetch` 일부만 수정함
>   - 기본적으로 `a `태그는 `get` 방식
>   - Rails 관련 질문 구글링시 `apidock` 나오면 이것 먼저 보기
>   - <%= form_tag do %> ~ <% end %> : **do** 잊지말고 적기 