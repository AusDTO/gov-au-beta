require 'prometheus/client'

class MetricsRecorder
  def self.instance
    @__instance__ ||= new
  end

  attr_reader :revisions_submitted

  def initialize
    @prometheus = Prometheus::Client.registry

    @revisions_submitted = Prometheus::Client::Counter.new(:revisions_submitted, 'A counter of revisions submitted')
    @prometheus.register(@revisions_submitted)

  end
end