module LoggingHelper

  def self.begin_request(request, current_user)
    RequestStore.store[:current_request] = request
    RequestStore.store[:current_user] = current_user
  end

  def self.current_user
    RequestStore.fetch(:current_user) { nil }
  end

  def self.current_request
    RequestStore.fetch(:current_request) { nil }
  end

  def self.cleanup
    RequestStore.clear!
  end

  def self.log_event(request,current_user,data)
    append_info_to_payload(request,current_user,data)
    Rails.logger.info Lograge.formatter.call(data)
  end

# logging payload additions
  def self.append_info_to_payload(request,current_user,payload)
    wanted_headers = %w[HTTP_X_CF_REQUESTID HTTP_CLIENT_IP HTTP_X_FORWARDED_FOR HTTP_X_FORWARDED_HOST HTTP_X_FORWARDED_PROTO HTTP_HOST HTTP_USER_AGENT HTTP_REFERER]
    payload[:ip] = request.remote_ip unless request.nil?
    # Cloudfoundry gives each request an ID in HTTP header X-Cf-Requestid so log it and any other headers
    payload[:headers] = request.headers.to_h.select { |key,_| wanted_headers.include? key } unless request.nil?
    # Add user context if available https://github.com/roidrage/lograge/issues/23
    payload[:user_id] = current_user.id unless current_user.nil?
    payload[:user_email] = current_user.email unless current_user.nil?
  end
end