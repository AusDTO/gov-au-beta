module EditorialHelper

  def form_type(node_clazz)
    # Because of development mode autoloading, the class may not exist until
    # we call constantize. Hence just catching the exception.
    "#{node_clazz.name}Form".constantize rescue NodeForm
  end

  def show_view_editorial_link?
    @node && @node.section && can?(:read, @node.section)
  end

  def show_new_page_link?
    @section && can?(:create_in, @section)
  end

  def show_edit_page_link?
    @node && can?(:manage, @node)
  end

end
