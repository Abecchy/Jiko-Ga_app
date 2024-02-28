class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    flash[:warning] = t('defaults.flash_message.require_login')
    redirect_to login_path
  end
end
