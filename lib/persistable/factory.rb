module Persistable
  class Factory

    def self.build(yml_file_path, defaults = {})
      adapter_config = load_yml(yml_file_path, defaults)
      raise ArgumentError.new("Invalid Parameter: There should be a Hash with :adapter key.") unless adapter_config[:adapter]
      adapter_config = adapter_config[:adapter].symbolize_keys
      raise ArgumentError.new("Invalid Parameter: There should be a Hash with :type key.") unless adapter_config[:type]

      adapter = case adapter_config.delete(:type)
      when 'filesystem'
        Persistable::FSAdapter.new(adapter_config)
      when 'mogilefs'
        Persistable::MogileFSAdapter.new(adapter_config)
      when 'memory'
        Persistable::MemoryAdapter.new(adapter_config)
      end

      return adapter
    end
    
    def self.load_yml(yml_file_path, defaults = {})
      defaults.merge!(YAML.load_file(yml_file_path).symbolize_keys) if yml_file_path && File.exists?(yml_file_path)
      return defaults
    end
    
  end
end