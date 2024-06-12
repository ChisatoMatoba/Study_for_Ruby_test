module ApplicationHelper
  def format_session_timestamp(timestamp)
    datetime = DateTime.strptime(timestamp.to_s, '%Y%m%d%H%M%S')
    datetime.in_time_zone('Tokyo').strftime('%Y-%m-%d %H:%M:%S')
  rescue ArgumentError
    'Invalid date'
  end
end
