class ApplicationController < ActionController::Base

    helper_method :current_user
    helper_method :logged_in?
    
    def current_user
       User.find_by(id: session[:user_id])
    end
    def logged_in?
        !current_user.nil?
    end
    def is_admin?
       @user=User.find_by(id: session[:user_id])
       if @user==nil
           return false
        elsif @user.role==true 
            puts @user
            return true
        else
            return false
        end
    end 
        
end
