module McStuffins
  class Config
    def self.dot_config
      if File.exists?('.mcstuffins.yaml')
        YAML.load_file('.mcstuffins.yaml')
      else
        {}
      end
    end

    def self.exists?
      File.exists?('.mcstuffins.yaml')
    end

    def self.write_default
      File.write('.mcstuffins.yaml', File.read(File.join(File.dirname(__FILE__), 'mcstuffins.yaml')))
    end
  end
end