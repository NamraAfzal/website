class Api::Sellers::BaseController < Api::BaseController
  before_action :authenticate_seller!
  skip_before_action :authenticate_user!
end
