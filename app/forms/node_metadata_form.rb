class NodeMetadataForm < Reform::Form
  property :parent_id
  collection :children do
    property :name, writable: false
    property :order_num, validates: {presence: true}
  end
  property :options, form: OptionsForm
end