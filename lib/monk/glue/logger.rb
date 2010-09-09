require 'logger'

module Kernel
  def logger
    $_logger ||= begin
      $_logger = ::Logger.new(root_path("log", "#{RACK_ENV}.log"))
      $_logger.level = ::Logger.const_get((monk_settings(:log_level) || :warn).to_s.upcase)
      $_logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      $_logger
    end
  end
  private :logger
end
