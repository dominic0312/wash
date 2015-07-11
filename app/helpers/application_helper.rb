module ApplicationHelper
  def nav_link(link_text, link_path, icon)
    class_name = current_page?(link_path) ? 'active' : ''
    content_tag(:li, :class => class_name, :role => "presentation") do
      link_to "<i class='fa fa-#{icon} user-icon'></i>".html_safe + link_text, link_path, class:'no-underline'
    end
  end
end
