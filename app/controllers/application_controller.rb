class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_notification_object
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    flash[:warning] = t('defaults.flash_message.require_login')
    redirect_to login_path
  end

  def set_notification_object
    @notifications = current_user.received_notifications.unread.order(created_at: :desc) if current_user
  end
end
