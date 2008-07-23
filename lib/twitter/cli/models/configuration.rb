class Configuration < ActiveRecord::Base
  serialize :data
  
  def self.[](key)
    key = find_by_key(key.to_s)
    key.nil? ? nil : key.data
  end
  
  def self.[]=(key, data)
    c = find_or_create_by_key(key.to_s)
    c.update_attribute :data, data
  end
end
