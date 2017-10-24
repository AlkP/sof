class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  private
  
  def author_of?(obj)
     if obj.try(:user_id) == current_user.try(:id)
       true
     else
       false
     end
  end
  
  helper_method :author_of?
end
