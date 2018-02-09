# Represents a human
module Human
  # Represents a dead human
  class Dead
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
      load_textures
      @draw_pos_x = @x - @image.width / 2
      @draw_pos_y = @y - @image.height / 2
    end

    def draw
      @image.draw(@draw_pos_x, @draw_pos_y, ZOrder::DEAD)
    end

    private

    def load_textures
      @image = Textures.get(:human_dead)
    end
  end
end
