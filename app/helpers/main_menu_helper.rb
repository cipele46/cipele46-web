# encoding: UTF-8

module MainMenuHelper

  def main_menu
    current_path = request.fullpath
    items = main_menu_items.map do |item|
      link = link_to item[0], item[1]
      klass = current_path.match(item[2]) ? 'current' : nil
      content_tag(:li, link, :class => klass)
    end
    content_tag :ul, sanitize(items.join)
  end


  private

  def main_menu_items
    [
      ["oglasi", root_path, /\A(\/\Z|\/ads)/],
      ["blog", blogs_path, /blog/],
      ["naša priča", page_path('nasa-prica'), /\A\/pages\/nasa-prica\Z/]
    ]
  end

end
