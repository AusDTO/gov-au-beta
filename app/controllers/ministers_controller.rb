class MinistersController < ApplicationController

  decorates_assigned :ministers

  def index
    @ministers = Minister.order(:name)
    fudge_order
  end

  #TODO Get rid of this fudge once full requirements are clear
  def fudge_order
    ministers.sort_by! {|minister| minister.sort_order }
  end

end
