# Represents game windows
module Windows
  # Represents a main game window
  # rubocop:disable ClassLength
  class Main < Gosu::Window
    include Resources
    include States
    def initialize
      super SettingsFile.get(:width), SettingsFile.get(:height)
      load_menu
      load_controls
      load_defaults
      load_player(SettingsFile.get(:width) / 2, SettingsFile.get(:height) / 2)
      set_music
      @state = GAME
    end

    def update
      case @state
      when GAME
        update_game
      when MENU
        update_menu
      when CONTROLS
        update_controls
      end
    end

    def draw
      case @state
      when GAME
        draw_game
      when MENU
        draw_menu
      when CONTROLS
        draw_controls
      end
    end

    def needs_cursor?
      true unless @state == GAME
    end

    def button_down(id)
      toggle_menu if [Gosu::KbEscape, Gosu::GP_BUTTON_6].include?(id)
    end

    def return_menu
      SettingsFile.save
      self.caption = Captions::PAUSE
      @state = MENU
    end

    def show_controls
      self.caption = Captions::CONTROLS
      @state = CONTROLS
    end

    def return_main_menu
      @player.die
      Game.load
      close
    end

    def exit_game
      Game.end
      close
    end

    private

    # menu

    def load_menu_textures
      @menu_background = Textures.get(:background_menu)
    end

    def load_menu
      load_menu_textures
      @menu_buttons = create_buttons(menu_buttons_opts)
      create_buttons_commands(@menu_buttons)
    end

    def draw_menu
      @menu_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_menu_buttons
    end

    def draw_menu_buttons
      @menu_buttons.map(&:draw)
    end

    def update_menu
      update_buttons(@menu_buttons)
    end

    def toggle_menu
      if @state == MENU
        Game.unpause
        @state = GAME
      elsif @state == GAME
        Game.pause
        @state = MENU
      end
    end

    def menu_buttons_opts
      {
        names: %w[CONTROLS END QUIT],
        commands: %i[show_controls return_main_menu exit_game]
      }
    end

    # controls

    def load_controls_textures
      @controls_background = Textures.get(:controls)
    end

    def load_controls
      load_controls_textures
      @controls_buttons = create_buttons(controls_buttons_opts)
      create_buttons_commands(@controls_buttons)
    end

    def draw_controls_buttons
      @controls_buttons.map(&:draw)
    end

    def draw_controls
      @controls_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_controls_buttons
    end

    def update_controls
      update_buttons(@controls_buttons)
    end

    def controls_buttons_opts
      {
        names: ['BACK'],
        commands: %i[return_menu]
      }
    end

    # game

    def load_game_textures
      @background = Textures.get(:background)
      @score_font = Gosu::Font.new(20)
      @controls_page = Textures.get(:controls)
    end

    def player_interaction
      @player.scare_humans(@humans)
      @player.collect_humans(@humans, @dead_humans)
    end

    def load_defaults
      self.fullscreen = SettingsFile.get(:fullscreen)
      self.caption = Captions::GAME
      load_game_textures
      @humans = []
      @dead_humans = []
    end

    def load_player(x = 320, y = 240)
      @player = Player::Alive.new
      @player.warp(x, y)
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

    def draw_game
      @background.draw(0, 0, ZOrder::BACKGROUND)
      @player.draw
      @humans.each(&:draw)
      @dead_humans.each(&:draw)
      draw_score
    end

    def update_player
      @player.accelerate if Gosu.button_down?(Gosu::KbW) ||
                            Gosu.button_down?(Gosu::GP_UP)
      @player.turn_left if Gosu.button_down?(Gosu::KbA) ||
                           Gosu.button_down?(Gosu::GP_LEFT)
      @player.turn_right if Gosu.button_down?(Gosu::KbD) ||
                            Gosu.button_down?(Gosu::GP_RIGHT)
      if Gosu.button_down?(Gosu::KbLeftShift) ||
         Gosu.button_down?(Gosu::GP_BUTTON_0)
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

    def update_game
      Game.toggle_pause if Gosu.button_down?(Gosu::KbP) ||
                           Gosu.button_down?(Gosu::GP_BUTTON_4)
      return if Game.paused?
      update_player
      update_humans
      update_music
    end

    # music

    def set_music
      @music = Sounds.get(:main_music)
      @music.volume = SettingsFile.get(:music_volume)
      if SettingsFile.get(:music)
        @music.play(true)
      else
        @music.stop
      end
    end

    def update_music(volume = 0.05)
      @music.volume += volume if Gosu.button_down?(Gosu::Kb0)
      @music.volume -= volume if Gosu.button_down?(Gosu::Kb9)
    end

    def buttons_opts
      {
        width: 150,
        height: 50,
        text: { value: '', height: 25 },
        command: { name: nil }
      }
    end

    def create_buttons(opts)
      buttons = []
      y_offset = height * 0.25
      opts[:names].each_with_index do |name, i|
        options = buttons_opts
        options[:text][:value] = name
        options[:command][:name] = opts[:commands][i]
        buttons << UIElements::Button.new(self, width * 0.05, y_offset, options)
        y_offset += height * 0.1
      end
      buttons
    end

    def create_buttons_commands(buttons)
      buttons.each do |button|
        button.create_command do
          window.send @command_name unless @command_name.nil?
        end
      end
    end

    # rubocop:disable MethodLength
    def update_buttons(buttons)
      buttons.each do |button|
        button.mouse_entered do |this|
          this.color = Colors::TEXT_MAIN
        end
        button.mouse_exited do |this|
          this.color = Colors::WHITE
        end
        button.mouse_clicked do |this|
          this.command
          this.color = Colors::WHITE
        end
      end
    end
    # rubocop:enable MethodLength
  end
  # rubocop:enable ClassLength
end
