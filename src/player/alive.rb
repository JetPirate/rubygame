# Represents the player
module Player
  # Represents the alive player
  class Alive
    attr_reader :score

    def initialize
      @x = @y = @vel_x = @vel_y = @angle = 0.0
      @speed = 1.0
      @score = 0
      load_textures
      set_music
    end

    def warp(x, y)
      @x = x
      @y = y
    end

    def turn_left
      # @car_drive.play(0.5, 1)
      @angle -= 4.5
    end

    def turn_right
      # @car_drive.play(0.5, 1)
      @angle += 4.5
    end

    def accelerate
      # @car_drive.play(0.5, 1)
      @vel_x += Gosu.offset_x(@angle, 0.5)
      @vel_y += Gosu.offset_y(@angle, 0.5)
    end

    def speed_up
      @speed += 0.1 if @speed < 3.0
    end

    def speed_down
      @speed -= 0.1 if @speed > 1.0
    end

    def move
      @x += @vel_x * @speed
      @y += @vel_y * @speed
      @x %= Game.properties[:width]
      @y %= Game.properties[:height]

      @vel_x *= 0.95
      @vel_y *= 0.95
    end

    def scare_humans(humans)
      humans.each do |human|
        human.run_away if Gosu.distance(@x, @y, human.x, human.y) < 200
      end
    end

    def collect_humans(humans, dead_humans)
      humans.reject! do |human|
        if Gosu.distance(@x, @y, human.x, human.y) < 35
          @score += 1
          human.death_sound.play(0.25, 2)
          dead_humans.push(Human::Dead.new(human.x, human.y))
          true
        else
          false
        end
      end
    end

    def die
      @car_idle_channel.stop
    end

    def draw
      @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
    end

    private

    def load_textures
      @image = Textures.get(:player)
    end

    def set_music
      @car_idle = Sounds.get(:car_idle)
      @car_drive = Sounds.get(:car_drive)
      @car_idle_channel = @car_idle.play(0.5, 1, true)
    end
  end
end
