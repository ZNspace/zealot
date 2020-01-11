# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_raven_context

  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token

  # Handle pundit error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def user_not_authorized
    flash[:warning] = '没有权限进行本次操作。'
    redirect_to(request.referrer || root_path)
  end

  # before_action :cors_preflight_check
  # after_action :cors_set_access_control_headers
  #
  # def after_sign_in_path_for(resource)
  #   sign_in_url = new_user_session_url
  #   if request.referer == sign_in_url
  #     super
  #   else
  #     stored_location_for(resource) || request.referer || root_path
  #   end
  # end
  #
  # def cors_set_access_control_headers
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  #   headers['Access-Control-Max-Age'] = '1728000'
  # end
  #
  # def cors_preflight_check
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  #   headers['Access-Control-Allow-Headers'] = '*'
  #   headers['Access-Control-Max-Age'] = '1728000'
  # end
  #
  # def user_not_authorized
  #   redirect_to root_url, alert: '你没有相应的权限访问该资源。'
  # end
end
