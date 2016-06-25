module EditorialHelper

  def form_type(node_clazz)
    "#{node_clazz.name}Form".constantize
  end

end