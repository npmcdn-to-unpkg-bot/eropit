class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
  end
end
