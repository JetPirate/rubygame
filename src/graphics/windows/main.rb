# Represents game windows
module Windows
  # Represents a main game window
  class Main < Gosu::Window
    def initialize
      super SettingsFile.get(:width), SettingsFile.get(:height)
      self.fullscreen = SettingsFile.get(:fullscreen)
      self.caption = 'Enjoy'
      @humans = []
      @dead_humans = []
      load_textures
      load_player(SettingsFile.get(:width) / 2, SettingsFile.get(:height) / 2)
      set_music
    end

    def update
      Game.toggle_pause if Gosu.button_down?(Gosu::KbP)
      return if Game.paused?
      update_player
      update_humans
      update_music
    end

    def draw
      @background.draw(0, 0, ZOrder::BACKGROUND)
      @player.draw
      @humans.each(&:draw)
      @dead_humans.each(&:draw)
      draw_score
    end

    def button_down(id)
      return_menu if id == Gosu::KbEscape
    end

    private

    def player_interaction
      @player.scare_humans(@humans)
      @player.collect_humans(@humans, @dead_humans)
    end

    def load_textures
      @background = Textures.get(:background)
      @score_font = Gosu::Font.new(20)
    end

    def load_player(x = 320, y = 240)
      @player = Player::Alive.new
      @player.warp(x, y)
    end

    def set_music
      @music = Sounds.get(:main_music)
      @music.volume = SettingsFile.get(:music_volume)
      if SettingsFile.get(:music)
        @music.play(true)
      else
        @music.stop
      end
    end

    def draw_score
      @score_font.draw(
        "Killed: #{@player.score}",
        10,
        10,
        ZOrder::UI,
        1.0,
        1.0,
        0xf0_f000f0
      )
    end

    def update_music(volume = 0.05)
      @music.volume += volume if Gosu.button_down?(Gosu::Kb0)
      @music.volume -= volume if Gosu.button_down?(Gosu::Kb9)
    end

    def update_player
      @player.accelerate if Gosu.button_down?(Gosu::KbW)
      @player.turn_left if Gosu.button_down?(Gosu::KbA)
      @player.turn_right if Gosu.button_down?(Gosu::KbD)
      if Gosu.button_down? Gosu::KbLeftShift
        @player.speed_up
      else
        @player.speed_down
      end
      @player.move
      player_interaction
    end

    def update_humans
      @humans.push(Human::Alive.new) if rand(100) < 4 && @humans.size < 25
    end

    def return_menu
      @player.die
      Game.load
      close
    end
  end
end
