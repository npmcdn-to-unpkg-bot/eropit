class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :basic_auth
  before_action :set_cache

  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == "admin" && "eropit333admin"
    end
  end

  def set_cache
    expires_in 1.day, public: true, must_revalidate: true
  end
end
