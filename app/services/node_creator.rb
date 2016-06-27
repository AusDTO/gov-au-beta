class NodeCreator
  def initialize(form)
    @form = form
    @klass = form.model.class
  end

  def perform!(user)
    @form.save do |params|
      content = @klass.content_attributes.select {|attr|
        params.has_key? attr
      }.collect {|attr|
        [attr, params.delete(attr)]
      }.to_h

      node = @klass.create!(params)
      Submission.new(revision: node.revise!(content)).tap do |submission|
        submission.submit!(user)
      end
    end
  end
end
