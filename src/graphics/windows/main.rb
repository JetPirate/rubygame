# frozen_string_literal: true

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
      load_defaults
      load_controls
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
      end
    end

    def draw
      case @state
      when GAME
        draw_game
      when MENU
        draw_menu
      end
    end

    def needs_cursor?
      return false if @state == GAME
      case SettingsFile.get(:controls_mode)
      when :keyboard then true
      when :gamepad  then false
      end
    end

    def button_down(id)
      toggle_menu if @controls[:BACK] == id
      case @state
      when MENU then update_buttons_with_gamepad(@menu_buttons, id)
      when GAME then update_buttons_with_gamepad(nil, id)
      end
    end

    def return_menu
      SettingsFile.save
      self.caption = Captions::PAUSE
      @state = MENU
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

    def load_controls
      mode = SettingsFile.get(:controls_mode)
      @controls = SettingsFile.get(:controls)[mode]
    end

    # menu

    def load_menu_textures
      @menu_background = Textures.get(:background_menu)
    end

    def load_menu
      load_menu_textures
      @menu_buttons = create_buttons(menu_buttons_opts)
      create_buttons_commands(@menu_buttons)
      return unless SettingsFile.get(:controls_mode) == :gamepad
      @menu_buttons.first.selected = true
    end

    def draw_menu
      @menu_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_menu_buttons
    end

    def draw_menu_buttons
      @menu_buttons.map(&:draw)
    end

    def update_menu
      update_buttons_with_mouse(@menu_buttons)
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
        names: %w[END QUIT],
        commands: %i[return_main_menu exit_game]
      }
    end

    # game

    def load_game_textures
      @background = Textures.get(:background)
      @score_font = Textures.get(:default_font)
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
      score = Game.paused? ? 'Paused' : "Killed: #{@player.score}"
      @score_font.draw_markup(
        score,
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
      @player.accelerate if Gosu.button_down?(@controls[:UP])
      @player.turn_left if Gosu.button_down?(@controls[:LEFT])
      @player.turn_right if Gosu.button_down?(@controls[:RIGHT])
      if Gosu.button_down?(@controls[:"SPEED UP"])
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
      @music.volume += volume if Gosu.button_down?(@controls[:"MUSIC UP"])
      @music.volume -= volume if Gosu.button_down?(@controls[:"MUSIC DOWN"])
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
        button = UIElements::Button.new(self, width * 0.05, y_offset, options)
        define_button_events(button)
        buttons << button
        y_offset += height * 0.1
      end
      buttons
    end

    def define_button_events(button)
      button.on_select do |this|
        this.color = Colors::TEXT_MENU
      end
      button.off_select do |this|
        this.color = Colors::WHITE
      end
    end

    def create_buttons_commands(buttons)
      buttons.each do |button|
        button.create_command do
          window.send @command_name unless @command_name.nil?
        end
      end
    end

    def change_selection(mode, items, index = nil)
      index ||= items&.find_index(&:selected?)
      return if index.nil?
      items[index].selected = false
      direction = mode == :down ? 1 : -1
      position = (index + direction) % items.count
      items[position].selected = true
    end

    def update_buttons_with_gamepad(buttons, button_id)
      controls = SettingsFile.get(:controls)[:gamepad]
      index = buttons&.find_index(&:selected?)
      case button_id
      when controls[:DOWN]   then change_selection(:down, buttons, index)
      when controls[:UP]     then change_selection(:up, buttons, index)
      when controls[:ACCEPT] then buttons&.at(index)&.command
      when controls[:PAUSE]  then Game.toggle_pause
      end
    end

    # rubocop:disable MethodLength
    def update_buttons_with_mouse(buttons)
      buttons.each do |button|
        button.mouse_entered do |this|
          this.selected = true
        end
        button.mouse_exited do |this|
          this.selected = false
        end
        button.mouse_clicked do |this|
          this.selected = true
          this.command
          this.selected = false
        end
      end
    end
    # rubocop:enable MethodLength
  end
  # rubocop:enable ClassLength
end
