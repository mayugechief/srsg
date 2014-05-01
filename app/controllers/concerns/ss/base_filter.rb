# coding: utf-8
module SS::BaseFilter
  extend ActiveSupport::Concern
  include SS::LayoutFilter
  
  included do
    before_action :logged_in?
    layout "ss/base"
  end
  
  private
    def logged_in?
      return @cur_user if @cur_user
      
      if session[:user]
        u = SS::Crypt.decrypt(session[:user]).to_s.split(",", 3)
        return unset_user redirect: true if u[1] != remote_addr
        return unset_user redirect: true if u[2] != request.user_agent
        @cur_user = SS::User.find u[0].to_i rescue nil
      end
      
      return @cur_user if @cur_user
      unset_user
      
      ref = request.env["REQUEST_URI"]
      ref = (ref == sns_mypage_path) ? "" : "?ref=" + CGI.escape(ref.to_s)
      redirect_to "#{sns_login_path}#{ref}"
    end
    
    def set_user(user, opt = {})
      if opt[:session]
        session[:user] = SS::Crypt.encrypt("#{user._id},#{remote_addr},#{request.user_agent}")
      end
      redirect_to sns_mypage_path if opt[:redirect]
      @cur_user = user
    end
    
    def unset_user(opt = {})
      session[:user] = nil
      redirect_to sns_login_path if opt[:redirect]
      @cur_user = nil
    end
end
