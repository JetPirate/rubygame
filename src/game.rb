# frozen_string_literal: true

require_relative 'settings_file'
require_relative 'events'
require_relative 'graphics'
require_relative 'sounds'
require_relative 'player'
require_relative 'human'

# Game module
module Game
  def self.load
    @menu = Windows::Menu.new
    @menu.show
  end

  def self.start
    @game = Windows::Main.new
    Game.properties[:width] = @game.width
    Game.properties[:height] = @game.height
    Game.properties[:paused] = false
    Game.properties[:fullscreen] = @game.fullscreen?
    @game.show
  end

  def self.settings
    @settings = Windows::Settings.new
    @settings.show
  end

  def self.end; end

  def self.reload
    Game.properties = {}
    SettingsFile.reload
    Textures.reload
    Sounds.reload
    Game.load
  end

  def self.properties=(properties)
    @properties = properties
  end

  def self.properties
    @properties ||= {}
  end

  def self.toggle_pause
    Game.properties[:paused] = Game.properties[:paused] ? false : true
  end

  def self.pause
    Game.properties[:paused] = true
  end

  def self.unpause
    Game.properties[:paused] = false
  end

  def self.paused?
    Game.properties[:paused]
  end
end
