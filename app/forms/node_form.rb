class NodeForm < Reform::Form
  property :section_id, type: Fixnum
  property :parent_id, type: Fixnum
  property :name

  property :content_block do
    property :body
  end

  # TODO: Decide if we want our validations from the model to the form
  extend ActiveModel::ModelValidations
  copy_validations_from Node
end