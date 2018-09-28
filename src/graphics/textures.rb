# frozen_string_literal: true

# Module for textures
module Textures
  def self.load
    @textures ||= {
      background: Gosu::Image.new('img/background.jpg', tileable: true),
      background_menu: Gosu::Image.new('img/menu.jpg', tileable: true),
      player: Gosu::Image.new('img/car.bmp'),
      player_1_stage: Gosu::Image.new('img/deathcar.bmp'),
      human: Gosu::Image.load_tiles('img/males.png', 25, 25),
      human_dead: Gosu::Image.new('img/dead.bmp'),
      default_label: Gosu::Image.new('img/default.bmp'),
      default_input_field: Gosu::Image.new('img/default_input_field.bmp'),
      controls: Gosu::Image.new('img/controls.jpg'),
      press_key: Gosu::Image.new('img/press_key.bmp'),
      sett_background: Gosu::Image.new('img/sett_background.jpg')
    }
  end

  def self.reload
    @textures = nil
    load
  end

  def self.get(texture)
    Textures.load[texture.to_sym]
  end
end
