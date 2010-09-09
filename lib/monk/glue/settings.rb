require 'yaml'

module Kernel
  def properties(key)
    $_properties ||= YAML.load_file(root_path("config", "settings.yml"))[RACK_ENV.to_sym]

    unless $_properties.include?(key)
      message = "No setting defined for #{key.inspect}."
      defined?(logger) ? logger.warn(message) : $stderr.puts(message)
    end

    $_properties[key]
  end
  private :properties
end
