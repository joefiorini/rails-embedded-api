class Api::UsersController < ActionController::Base

  def index
    render json: { users: [{id: 1, email: 'joe@joefiorini.com'}]}
  end
end
