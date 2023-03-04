# frozen_string_literal: true

# This channel will be used to notify users that some item has been created, updated or deleted.
class ChangesChannel < ApplicationCable::Channel
  class << self
    def notify(class_name: nil, id: nil, action: nil, data: {})
      room = [class_name, id, action].filter(&:present?).join(' ')

      broadcast_to(room, data)
    end

    def notify_item_reload(item)
      notify(class_name: item.class.name, id: item.id, action: 'reload')
    end

    def notify_to_list_pages(item)
      notify(class_name: item.class.name, data: item.as_json)
    end
  end

  def subscribed
    # room = "#{params[:model]} #{params[:id]} #{params[:action]}".split(' ').filter(&:present?).join(' ')
    room = %i[model id action].map { |field| params[field] }.filter(&:present?).join(' ')

    stream_for room
  end
end
