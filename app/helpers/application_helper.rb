module ApplicationHelper
  def inside_layout(parent_layout)
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

  def sunstate_class()
    if ENV['ENABLE_EASTER_EGG']
      today = Time.now
      now = Time.now.utc
      latitude = -35.2770817
      longitude = 149.1267962
      sun_times = SunTimes.new

      if now < sun_times.rise(today, latitude, longitude) or now > sun_times.set(today, latitude, longitude)
        "night"
      elsif now-1.hours < sun_times.rise(today, latitude, longitude)
        "dawn"
      elsif now+1.hours > sun_times.set(today, latitude, longitude)
        "dusk"
      end
    end
  end
end
