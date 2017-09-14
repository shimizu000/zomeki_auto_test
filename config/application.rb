module ZomekiAutoTest
  class Application < Rails::Application
    config.active_job.queue_adapter = :delayed_job
  end
end