# frozen_string_literal: true

module Resources
  module Captions
    # rubocop:disable MutableConstant
    MAIN_MENU = 'MENU'
    GAME = 'GAME'
    SETTINGS = 'SETTINGS'
    CONTROLS = 'CONTROLS'
    PAUSE = 'PAUSE'
    # rubocop:enable MutableConstant
  end
  module Colors
    # rubocop:disable LeadingCommentSpace
    WHITE = 0xff_ff_ff_ff     #ffffff
    TEXT_MENU = 0xff_6c_a8_f7 #6ca8f7
    TEXT_MAIN = 0xff_e7_6f_0d #e76f0d
    # rubocop:enable LeadingCommentSpace
  end
  module Controls
    # rubocop:disable MethodLength, CyclomaticComplexity
    def self.key_id_to_s(id)
      case id
      when Gosu::KbQ         then 'Q'
      when Gosu::KbW         then 'W'
      when Gosu::GP_UP       then 'UP'
      when Gosu::KbE         then 'E'
      when Gosu::KbR         then 'R'
      when Gosu::KbT         then 'T'
      when Gosu::KbY         then 'Y'
      when Gosu::KbU         then 'U'
      when Gosu::KbI         then 'I'
      when Gosu::KbO         then 'O'
      when Gosu::KbP         then 'P'
      when Gosu::GP_BUTTON_4 then 'Button 4'
      when Gosu::KbA         then 'A'
      when Gosu::GP_LEFT     then 'LEFT'
      when Gosu::KbS         then 'S'
      when Gosu::GP_DOWN     then 'DOWN'
      when Gosu::KbD         then 'D'
      when Gosu::GP_RIGHT    then 'RIGHT'
      when Gosu::KbF         then 'F'
      when Gosu::KbG         then 'G'
      when Gosu::KbH         then 'H'
      when Gosu::KbJ         then 'J'
      when Gosu::KbK         then 'K'
      when Gosu::KbL         then 'L'
      when Gosu::KbZ         then 'Z'
      when Gosu::KbX         then 'X'
      when Gosu::KbC         then 'C'
      when Gosu::KbV         then 'V'
      when Gosu::KbB         then 'B'
      when Gosu::KbN         then 'N'
      when Gosu::KbM         then 'M'
      when Gosu::KbLeftShift then 'LShift'
      when Gosu::GP_BUTTON_0 then 'Button 0'
      when Gosu::Kb1         then '1'
      when Gosu::Kb2         then '2'
      when Gosu::Kb3         then '3'
      when Gosu::Kb4         then '4'
      when Gosu::Kb5         then '5'
      when Gosu::Kb6         then '6'
      when Gosu::Kb7         then '7'
      when Gosu::Kb8         then '8'
      when Gosu::Kb9         then '9'
      when Gosu::Kb0         then '0'
      when Gosu::KbEscape    then 'ESC'
      when Gosu::GP_BUTTON_6 then 'Button 6'
      else
        'Undefined'
      end
    end

    def self.s_to_key_id(s)
      case s
      when 'W'      then Gosu::KbW
      when 'S'      then Gosu::KbS
      when 'A'      then Gosu::KbA
      when 'D'      then Gosu::KbD
      when 'LShift' then Gosu::KbLeftShift
      when 'P'      then Gosu::KbP
      when '0'      then Gosu::Kb0
      when '9'      then Gosu::Kb9
      when 'ESC'    then Gosu::KbEscape
      end
    end
    # rubocop:enable MethodLength, CyclomaticComplexity
  end
end
