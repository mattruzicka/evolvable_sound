require 'dino'

module Client
  class CommandLineController
    class << self
      def display_program_name
        green_name = green_text('evolvable sound')
        type_out("\n \e[32m#{green_name}\e[0m\n\n")
      end

      def display_sound_name(name)
        type_out(green_text(" #{name}"))
      end

      RATING_PROMPT = 'rating: '

      def display_rating_prompt
        type_out("\n #{green_text(RATING_PROMPT)}")
      end

      def get_rating(replay_pause, replay_block)
        get_rating_from_controller(replay_pause, replay_block)
      end

      BOARD = Dino::Board.new(Dino::TxRx::Serial.new)
      POTENTIOMETER = Dino::Components::Sensor.new(pin: 'A0', board: BOARD)
      BUTTON = Dino::Components::Button.new(pin: 13, board: BOARD)

      BUTTON.up do
        @@final_rating = @@p_data
        @@button_up = true
      end

      POTENTIOMETER.when_data_received do |data|
        @@p_data = data
      end

      def get_rating_from_controller(replay_pause, replay_block)
        @@button_up = false
        replay_at = Time.now.utc

        until @@button_up
          if (Time.now.utc - replay_at) >= replay_pause
            replay_block.call
            replay_at = Time.now.utc
          end
          rating = normalize_rating(@@p_data)
          print("\r #{green_text(RATING_PROMPT)}#{rating} \b")
          sleep 0.05
        end

        @@button_up = false
        @final_rating = normalize_rating(@@final_rating)
      end

      MAX_RAW_RATING = 1023.0

      def normalize_rating(data)
        ((data.to_f / MAX_RAW_RATING) * 100).round
      end

      def accept_rating(rating)
        (RATING_PROMPT.length + @final_rating.to_s.length).times do
          print("\b \b")
          sleep 0.03
        end
        type_out("#{green_text(rating)}\n\n")
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
