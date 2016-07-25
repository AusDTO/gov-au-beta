require "administrate/field/base"

class StructField < Administrate::Field::Base
  def to_s
    data.to_h.to_json
  end
end
