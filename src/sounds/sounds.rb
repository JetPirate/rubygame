# Module for sounds
module Sounds
  def self.load
    @sounds ||= {
      menu_music: Gosu::Song.new('wav/ost0_game.wav'),
      main_music: Gosu::Song.new('wav/ost1_game.wav'),
      car_idle: Gosu::Sample.new('wav/caridle.wav'),
      car_drive: Gosu::Sample.new('wav/cardrive.wav'),
      human_death: Gosu::Sample.new('wav/human_death.wav')
    }
  end

  def self.get(sound)
    Sounds.load[sound]
  end
end
