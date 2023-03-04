# frozen_string_literal: true

# Base application controller class.
class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authenticate_user

  def parse_json_params
    params.each_key do |key|
      params[key] = JSON.parse(params[key]) if params[key].is_a?(String) && params[key].valid_json?
    end
  end

  def route_not_found(exception = nil)
    render_error(status: 404, message: exception || I18n.t('.route_not_found'))
  end

  protected

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound => e
    route_not_found(e)
  rescue ActiveRecord::RecordNotFound => e
    render_error(status: 404, message: e.message)
  end

  def render_item_errors(status: :unprocessable_entity, message: @item.errors.full_messages.join(', '), details: @item.errors.full_json)
    render_error(status: status, message: message, details: details)
  end

  def item_errors(item: @item, status: nil, message: nil, details: nil)
    render_error(
      status: status || :unprocessable_entity,
      message: message || item.errors.full_messages,
      details: details || item.errors.full_json(options: { recursive_details: true })
    )
  end

  def authenticate_user
    @current_user = AuthorizeApiRequest.call(request.headers).result
    return render_unauthorized unless @current_user
  end

  def render_error(status: nil, message: nil, details: {})
    render json: { message: message, details: details }, status: status
  end

  def delete_cookie(name, options = {})
    options.stringify_keys!
    cookies.encrypted[name.to_s] = options.merge(name: name.to_s, value: '', expires: Time.at(0))
  end

  def render_unauthorized
    render_error status: 401, message: 'Unauthorized'
  end

  def json_metadata(resources)
    return {
      current_page: resources.current_page,
      per_page:  resources.per_page,
      prev_page: resources.previous_page,
      next_page: resources.next_page,
      total_pages: resources.total_pages,
      total_count: resources.total_entries
    }
  end
end
