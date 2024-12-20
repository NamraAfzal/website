class Api::Users::BaseController < Api::BaseController
  before_action :authenticate_user!

end
