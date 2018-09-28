# frozen_string_literal: true

# Represents a human
module Human
  # Represents an alive human
  class Alive
    attr_reader :x, :y, :death_sound

    def initialize
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @speed = 5.0
      load_textures
      set_music
      set_position
      set_color
    end

    def draw
      image = @animation[Gosu.milliseconds / 100 % @animation.size]
      image.draw(
        @x - image.width / 2.0,
        @y - image.height / 2.0,
        ZOrder::HUMAN,
        1,
        1,
        @color,
        :add
      )
    end

    def accelerate
      @angle = rand(360)
      @vel_x += Gosu.offset_x(@angle, 0.5)
      @vel_y += Gosu.offset_y(@angle, 0.5)
    end

    def move
      @x += @vel_x * @speed
      @y += @vel_y * @speed
      @x %= Game.properties[:width]
      @y %= Game.properties[:height]

      @vel_x *= 0.95
      @vel_y *= 0.95
    end

    def run_away
      accelerate
      move
    end

    private

    def load_textures
      @animation = Textures.get(:human)
    end

    def set_music
      @death_sound = Sounds.get(:human_death)
    end

    def set_position
      @x = rand * Game.properties[:width]
      @y = rand * Game.properties[:height]
    end

    def set_color
      @color = Gosu::Color.new(0xff_00_00_00)
      @color.red = rand(256 - 40) + 40
      @color.green = rand(256 - 40) + 40
      @color.blue = rand(256 - 40) + 40
    end
  end
end
