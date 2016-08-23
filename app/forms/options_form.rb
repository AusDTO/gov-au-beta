require 'reform/form/coercion'

class OptionsForm < Reform::Form
  feature Coercion
  property :placeholder, type: Types::Form::Bool
  property :toc, type: Types::Form::Int,
           validates: { inclusion: [nil, 0, 1, 2] }
end