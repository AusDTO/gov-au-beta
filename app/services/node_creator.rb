class NodeCreator
  def initialize(form)
    @form = form
    @klass = form.model.class
  end

  def perform!(user)
    @form.save do |params|
      body = params.delete(:content_body)
      node = @klass.create!(params)
      Submission.new(revision: node.revise!(content_body: body)).tap do |submission|
        submission.submit!(user)
      end
    end
  end
end
