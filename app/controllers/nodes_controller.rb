class NodesController < ApplicationController
  def show
    @node = Node.find(params[:id])
    render :show
  end
end