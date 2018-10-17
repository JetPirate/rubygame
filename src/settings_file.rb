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
    width, height = current_resolution
    @settings = {
      fullscreen: true,
      width: width.to_i,
      height: height.to_i,
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
          BACK: Gosu::KbEscape,
          ACCEPT: Gosu::KbEnter
        },
        gamepad: {
          UP: Gosu::GP_UP,
          DOWN: Gosu::GP_DOWN,
          LEFT: Gosu::GP_LEFT,
          RIGHT: Gosu::GP_RIGHT,
          "SPEED UP": Gosu::GP_BUTTON_0,
          PAUSE: Gosu::GP_BUTTON_4,
          "MUSIC UP": Gosu::GP_BUTTON_9,
          "MUSIC DOWN": Gosu::GP_BUTTON_11,
          BACK: Gosu::GP_BUTTON_6,
          ACCEPT: Gosu::GP_BUTTON_0
        }
      }
    }
    SettingsFile.save
  end
  # rubocop:enable MethodLength

  def self.save
    File.open('settings.yaml', 'w') { |f| f.write(@settings.to_yaml) }
  end

  # rubocop:disable MethodLength
  def self.current_resolution
    case Gem::Platform.local.os
    when 'linux'
      `xrandr`.scan(/current (\d+) x (\d+)/).flatten
    when 'mingw32'
      require 'fiddle'
      usr32 = Fiddle.dlopen('user32')
      gsm = Fiddle::Function.new(usr32['GetSystemMetrics'],
                                 [Fiddle::TYPE_LONG],
                                 Fiddle::TYPE_LONG)
      [gsm.call(0), gsm.call(1)]
    end
  end
  # rubocop:enable MethodLength
end
