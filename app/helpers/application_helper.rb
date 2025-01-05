module ApplicationHelper
  def format_session_timestamp(timestamp)
    datetime = DateTime.strptime(timestamp.to_s, '%Y%m%d%H%M%S')
    datetime.in_time_zone('Tokyo').strftime('%Y-%m-%d %H:%M:%S')
  rescue ArgumentError
    'Invalid date'
  end

  def role_color(role)
    case role
    when 'owner'
      'bg-warning'
    when 'admin'
      'bg-warning bg-opacity-25'
    else
      ''
    end
  end
end
