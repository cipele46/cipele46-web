# encoding: UTF-8

module MainMenuHelper

  def main_menu
    current_path = request.fullpath
    items = main_menu_items.map do |item|
      link = link_to item[:text], item[:url]
      klass = current_path.match(item[:regex]) ? 'current' : nil
      content_tag(:li, link, :class => klass)
    end
    content_tag :ul, sanitize(items.join)
  end


  private

    def main_menu_items
      [
        {:text => "oglasi", :url => root_path, :regex => /\A(\/\Z|\/ads)/},
        {:text => "blog", :url => blog_index_path, :regex => /blog/},
        {:text => "naša priča", :url => page_path('nasa-prica'), :regex => /\A\/pages\/nasa-prica\Z/}
      ]
    end
end
