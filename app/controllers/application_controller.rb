class ApplicationController < ActionController::Base
  protect_from_forgery

  def unique_url
    Time.now.to_i
  end

end
