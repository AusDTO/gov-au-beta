module EditorialHelper

  def form_type(node_clazz)
    "#{node_clazz.name}Form".constantize
  end

  def show_new_page_link?
    @section && can?(:create_in, @section)
  end

  def show_edit_page_link?
    @node && can?(:manage, @node)
  end

end
