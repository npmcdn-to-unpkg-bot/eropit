class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :basic_auth

  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == "admin" && "eropit333admin"
    end
  end
end
