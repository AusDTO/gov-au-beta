class NodeCreator
  def initialize(section, form)
    @section = section
    @form    = form
    @klass   = form.model.class
  end

  def perform!(user)
    @form.save do |params|
      content = content_from_params(params)
      node = @klass.new params.delete_if {|k, _v| content.has_key?(k) }
      node.section = @section
      node.save!
      Submission.new(revision: node.revise!(content)).tap do |submission|
        submission.submit!(user)
      end
    end
  end

  def content_from_params(params)
    @klass.content_attributes.select {|attr|
      params.has_key? attr
    }.collect {|attr|
      [attr, params.delete(attr)]
    }.to_h
  end
end
