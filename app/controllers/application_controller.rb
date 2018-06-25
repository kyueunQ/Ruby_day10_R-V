class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # view에서 사용할 수 있도록 설정함
  helper_method :user_signed_in?
  
  # 현재 로그인 된 상태니?
  def user_signed_in?
      session[:current_user].present?
  end
  
  # 로그인 되어 있지 않으면 로그인하는 페이지로 이동시켜주기
  def authenticate_user!
    redirect_to '/sign_in' unless user_signed_in?
  end
  
  # 현재 로그인 된 사람은 누구니?
  def current_user
      # 현재 로그인은 돼있니?
        if user_signed_in?
          @current_user = User.find(session[:current_user])
        
        end
      
  end
end
