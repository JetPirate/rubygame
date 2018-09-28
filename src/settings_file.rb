# frozen_string_literal: true

require 'yaml'

# Represents module for game settings
module SettingsFile
  def self.load
    @settings || SettingsFile.fetch
  end

  def self.fetch
    @settings = YAML.safe_load(File.open('settings.yaml'), [Hash, Symbol, Array])
  rescue StandardError => e
    puts "Could not load settings: #{e.message}"
  ensure
    SettingsFile.create if @settings.nil? || @settings.empty?
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

  # rubocop:disable MethodLength
  def self.create
    @settings = {
      fullscreen: true,
      width: 1920,
      height: 1080,
      music: true,
      music_volume: 0.5,
      controls_mode: :keyboard,
      controls: {
        keyboard: {
          UP: Gosu::KbW,
          DOWN: Gosu::KbS,
          LEFT: Gosu::KbA,
          RIGHT: Gosu::KbD,
          "SPEED UP": Gosu::KbLeftShift,
          PAUSE: Gosu::KbP,
          "MUSIC UP": Gosu::Kb0,
          "MUSIC DOWN": Gosu::Kb9,
          BACK: Gosu::KbEscape
        },
        gamepad: {
          UP: Gosu::GP_UP,
          DOWN: Gosu::GP_DOWN,
          LEFT: Gosu::GP_LEFT,
          RIGHT: Gosu::GP_RIGHT,
          "SPEED UP": Gosu::GP_BUTTON_0,
          PAUSE: Gosu::GP_BUTTON_4,
          "MUSIC UP": Gosu::Kb0, # TODO
          "MUSIC DOWN": Gosu::Kb9,
          BACK: Gosu::GP_BUTTON_6
        }
      }
    }
    SettingsFile.save
  end
  # rubocop:enable MethodLength

  def self.save
    File.open('settings.yaml', 'w') { |f| f.write(@settings.to_yaml) }
  end
end
