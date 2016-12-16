
require 'gosu'

module ZOrder
    Background, Dead, Human, Player, UI = *0..4
end

class Dead_Human
    attr_accessor :x, :y

    def initialize(animation, x, y)
        @animation = animation
        self.x = x
        self.y = y
    end

    def draw
        img = @animation
        img.draw(@x - img.width / 2, @y - img.height / 2, ZOrder::Dead)
    end
end

class Human
    attr_reader :x, :y
    attr_accessor :scared
    attr_accessor :scared_times

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color.new(0xff_000000)
        @color.red = rand(256 - 40) + 40
        @color.green = rand(256 - 40) + 40
        @color.blue = rand(256 - 40) + 40
        @x = rand * 640
        @y = rand * 480
        self.scared = false
        self.scared_times = 0
    end

    def draw
        img = @animation[Gosu.milliseconds / 100 % @animation.size]
        img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
                 ZOrder::Human, 1, 1, @color, :add)
    end
end

class Player
    attr_reader :score

    def initialize
        @image = Gosu::Image.new('img/car.bmp')
        @car_idle = Gosu::Sample.new('wav/caridle.wav')
        @car_drive = Gosu::Sample.new('wav/cardrive.wav')
        @dead = Gosu::Image.new('img/dead.bmp')
        @death = Gosu::Sample.new('wav/death.wav')
        @scared_man = Gosu::Sample.new('wav/scaredman.wav')
        @scared_woman = Gosu::Sample.new('wav/scaredwoman.wav')
        @car_idle.play(0.5, 1, true)
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @speed = 1.0
        @score = 0
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
        @x %= 640
        @y %= 480

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def collect_humans(humans, dead_humans)
        humans.reject! do |human|
            if Gosu.distance(@x, @y, human.x, human.y) < 50
                # @scaredman.play || @scaredwoman.play
                human.scared = true
                if human.scared_times < 1 && human.scared
                    @scared_woman.play(0.05, 1)
                    human.scared_times += 1
                end
                false
            end
            if Gosu.distance(@x, @y, human.x, human.y) < 35
                @score += 1
                @death.play(0.25, 2)
                human.scared = false
                dead_humans.push(Dead_Human.new(@dead, human.x, human.y))
                true
            else
                human.scared = false
                human.scared_times = 0
                false
            end
        end
    end

    def draw
        @image.draw_rot(@x, @y, ZOrder::Player, @angle)
    end
end

class GameWindow < Gosu::Window
    def initialize
        super 640, 480
        self.caption = 'Enjoy'
        @music = Gosu::Song.new(self, 'wav/Hydrogen.wav')
        @music.volume = 0.5
        @music.play(true)
        @font = Gosu::Font.new(20)

        @background_image = Gosu::Image.new('img/background.jpg', tileable: true)

        @player = Player.new
        @player.warp(320, 240)
        @human_anim = Gosu::Image.load_tiles('img/males.png', 25, 25)
        @human_dead = Gosu::Image.new('img/dead.bmp')
        @humans = []
        @dead_humans = []
    end

    def update
        if Gosu.button_down?(Gosu::KbA) || Gosu.button_down?(Gosu::GpLeft)
            @player.turn_left
        end
        if Gosu.button_down?(Gosu::KbD) || Gosu.button_down?(Gosu::GpRight)
            @player.turn_right
        end
        if Gosu.button_down?(Gosu::KbW) || Gosu.button_down?(Gosu::GpButton0)
            @player.accelerate
        end
        if Gosu.button_down? Gosu::KbLeftShift
            @player.speed_up
        else
            @player.speed_down
        end
        @music.volume += 0.05 if Gosu.button_down?(Gosu::KbNumpadAdd)
        @music.volume -= 0.05 if Gosu.button_down?(Gosu::KbNumpadSubtract)

        @player.move
        @player.collect_humans(@humans, @dead_humans)

        @humans.push(Human.new(@human_anim)) if rand(100) < 4 && @humans.size < 25
    end

    def draw
        @player.draw
        @background_image.draw(0, 0, ZOrder::Background)
        @humans.each(&:draw)
        @dead_humans.each(&:draw)
        @font.draw("Killed: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xf0_f000f0)
    end

    def button_down(id)
        close if id == Gosu::KbEscape
    end
end

window = GameWindow.new
window.show
