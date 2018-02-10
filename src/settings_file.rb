require 'yaml'
# Represents module for game settings
module SettingsFile
  def self.load
    @settings ||= SettingsFile.fetch
  end

  def self.fetch
    settings = begin
      YAML.safe_load(File.open('settings.yaml'), [Hash, Symbol])
    rescue StandardError => e
      puts "Could not load settings: #{e.message}"
    end
    return SettingsFile.default if settings.nil? || settings.empty?
    settings
  end

  def self.get(setting)
    SettingsFile.load[setting.to_sym]
  end

  def self.set(setting, value)
    SettingsFile.load[setting.to_sym] = value
  end

  def self.reload
    @settings = nil
    SettingsFile.load
  end

  def self.default
    {
      fullscreen: false,
      width: 640,
      height: 480,
      music: true,
      music_volume: 0.5
    }
  end

  def self.save
    File.open('settings.yaml', 'w') { |f| f.write(@settings.to_yaml) }
  end
end
