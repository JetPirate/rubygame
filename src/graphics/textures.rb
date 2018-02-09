# Module for textures
module Textures
  def self.load(fullscreen = false)
    dir = fullscreen ? 'img-hd' : 'img'
    @textures ||= {
      background: Gosu::Image.new("#{dir}/background.jpg", tileable: true),
      background_menu: Gosu::Image.new("#{dir}/menu.jpg", tileable: true),
      player: Gosu::Image.new('img/car.bmp'),
      player_1_stage: Gosu::Image.new('img/deathcar.bmp'),
      human: Gosu::Image.load_tiles('img/males.png', 25, 25),
      human_dead: Gosu::Image.new('img/dead.bmp'),
      default_button: Gosu::Image.new('img/default_button.bmp'),
      controls: Gosu::Image.new("#{dir}/controls.jpg")
    }
  end

  def self.reload(fullscreen)
    @textures = nil
    load(fullscreen)
  end

  def self.get(texture)
    Textures.load[texture.to_sym]
  end
end
