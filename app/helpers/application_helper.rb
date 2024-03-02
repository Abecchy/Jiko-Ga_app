module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'JikogArtMuseum'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def flash_background_color(type)
    case type.to_sym
    when :success then 'bg-green-100 border border-green-400 text-green-700'
    when :info then 'bg-blue-100 border border-blue-400 text-blue-700'
    when :warning then 'bg-yellow-100 border border-yellow-400 text-yellow-700'
    when :danger then 'bg-red-100 border border-red-400 text-red-700'
    else 'bg-gray-100'
    end
  end
end
