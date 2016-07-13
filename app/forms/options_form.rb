require 'reform/form/coercion'

class OptionsForm < Reform::Form
  feature Coercion
  property :toc, type: Types::Form::Int,
           validates: {
               numericality: {
                   only_integer: true,
                   greater_than_or_equal_to: 0,
                   less_than_or_equal_to: 2,
                   allow_nil: true
               }
           }
end