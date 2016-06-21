# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  def author_request
    Notifier.author_request(Request.first)
  end
end
