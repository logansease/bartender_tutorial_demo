class ApplicationController < ActionController::Base
   protect_from_forgery :except => [:fb_signin, :create_fb]
  
  #helper is only available in views, so include the helper in controller
  #by putting here, get it in all controllers
  include SessionsHelper

   before_filter :add_www_subdomain

   private
   def add_www_subdomain

    #if request.ssl?
    #     redirect_to :protocol => "http://"
    #end

     unless /^www/.match(request.host) or /^localhost/.match(request.host)  or request.host.include?("herokuapp.com") or request.host.include?("local.")
       redirect_to("#{request.protocol}www.#{request.host_with_port}#{request.fullpath}",
                   :status => 301)
     end
   end

  
end
