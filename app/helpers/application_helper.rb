module ApplicationHelper
  include Pagy::Frontend

  def format_deadline(end_date)
    puts "end_date: #{end_date}"
    return "Due: --" if end_date.nil?

    days_remaining = (end_date.to_date - Date.today).to_i

    case days_remaining
    when -Float::INFINITY..-1
      "Due: Overdue by #{days_remaining.abs} day#{'s' if days_remaining.abs > 1}"
    when 0
      "Due: Today"
    when 1
      "Due: Tomorrow"
    when 2..Float::INFINITY
      "Due: In #{days_remaining} day#{'s' if days_remaining > 1}"
    end
  end
end
