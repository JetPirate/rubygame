require_relative 'graphics'
require_relative 'sounds'
require_relative 'player'
require_relative 'human'

# Game module
module Game
  def self.load(options = {})
    @menu = Windows::Menu.new(options)
    @menu.show
  end

  def self.start(options = {})
    @game = Windows::Main.new(options)
    Game.properties[:width] = @game.width
    Game.properties[:height] = @game.height
    Game.properties[:paused] = false
    Game.properties[:fullscreen] = options[:fullscreen] || false
    @game.show
  end

  def self.end; end

  def self.reload(options = {})
    Textures.reload(options[:fullscreen])
    load(options)
  end

  def self.properties
    @properties ||= {}
  end

  def self.toggle_pause
    Game.properties[:paused] = Game.properties[:paused] ? false : true
  end

  def self.paused?
    Game.properties[:paused]
  end
end
