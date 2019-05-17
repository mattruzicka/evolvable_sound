require 'timeout'
require 'io/console'
require 'dino'

module Client
  class CommandLine
    class << self
      def display_program_name
        green_name = green_text('evolvable sound')
        type_out("\n \e[32m#{green_name}\e[0m\n\n")
      end

      def display_sound(evolvable_sound)
        type_out(green_text(" #{evolvable_sound.name}"))
      end

      RATING_PROMPT = 'enter rating (0-9): '

      def display_rating_prompt
        type_out("\n #{green_text(RATING_PROMPT)}")
      end

      VALID_RATINGS = %w(0 1 2 3 4 5 6 7 8 9)

      def get_rating(replay_pause, replay_block)
        rating = get_rating_with_timeout(replay_pause, replay_block)
        rating.strip! if rating

        until VALID_RATINGS.include?(rating)
          print("\e[1A                 ")
          _rows, cols = IO.console.winsize
          print("\r#{console_width_in_spaces}")
          print("\r #{green_text(RATING_PROMPT)}")
          rating = get_rating_with_timeout(replay_pause, replay_block)
          rating.strip!
        end
        rating.to_i
      end

      def console_width_in_spaces
        _rows, cols = IO.console.winsize
        ' ' * cols
      end

      def get_rating_with_timeout(replay_pause, replay_block)
        begin
          Timeout::timeout(replay_pause) { gets }
        rescue
          replay_block.call
          get_rating_with_timeout(replay_pause, replay_block)
        end
      end

      CLEAR_RATING_SPACES = ' ' * (RATING_PROMPT.length + 1)

      def accept_rating(rating)
        type_out("\e[1A#{CLEAR_RATING_SPACES}", type_speed: 0.02)
        print(console_width_in_spaces)
        print("\e[1A\r")
        type_out(" #{green_text(rating)}\n\n")
      end

      SEX_EMOJIS = ["😘",
                    "😙",
                    "🔥",
                    "❤️ ",
                    "💛",
                    "💚",
                    "💙",
                    "💜",
                    "🌋",
                    "🍆",
                    "🛏️ ",
                    "🏩",
                    "👌",
                    "💦",
                    "🔩",
                    "👅",
                    "😉",
                    "🍌",
                    "🚇",
                    "🍑",
                    "♨️ ",
                    "🌶️ ",
                    "💋",
                    "🌰",
                    "🎆",
                    "💥",
                    "🐫"]

      def display_sound_parent_1(sound_name)
        type_out("\n ")
        green_sound_name = green_text(sound_name)
        type_out("#{green_sound_name} ", type_speed: 0.12)
        sleep 0.5

        SEX_EMOJIS.sample(12).each do |emoji|
          print("\r #{green_sound_name} #{red_text(emoji)}")
          sleep 0.12
        end
        sleep 0.5
      end

      def display_sound_parent_2(sound_name)
        type_out(green_text(" #{sound_name}"), type_speed: 0.12)
        sleep(2.4)
        type_out("\n\n\n")
      end

      def type_out(string, type_speed: 0.03)
        string.split('').each do |char|
          print(char)
          sleep(type_speed)
        end
      end

      def green_text(text)
        "\e[32m#{text}\e[0m"
      end

      def red_text(text)
        "\e[31m#{text}\e[0m"
      end
    end
  end
end
