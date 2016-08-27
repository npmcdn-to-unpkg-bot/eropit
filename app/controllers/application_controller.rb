class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :basic_auth
  before_action :set_cache
  before_action :set_footer_tags

  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == "admin" && "eropit333admin"
    end
  end

  def set_cache
    expires_in 1.day, public: true, must_revalidate: true
  end

  def set_footer_tags
    @footer_tags = ActsAsTaggableOn::Tag.most_used(6)
  end
end
