require 'evolvable_sound/version'
require 'evolvable_sound/sonic_pi_synthinfo'
require 'evolvable_sound/synth'
require 'evolvable_sound/sample'
require 'evolvable_sound/client/command_line'
require 'evolvable'
require 'sonic_pi'

class EvolvableSound
  include Evolvable

  def self.play_song(population_name)
    stop_sound
    play_sound("./songs/#{population_name}")
  end

  def self.evolvable_gene_pool
    Synth.define_evolvable_genes
    Sample.define_evolvable_genes
    gene_pool = Synth.classes.map { |klass| [klass, 3] }
    gene_pool.concat Sample.classes.map { |klass| [klass, 1] }
    gene_pool
  end

  def self.evolvable_genes_count
    5
  end

  def self.evolvable_evaluate!(bands)
    bands.each(&:evaluate!)
  end

  def self.evolvable_initialize(genes, population, object_index)
    sound = new
    sound.genes = genes
    sound.population = population
    sound.name = "sound_#{population.generation_count}_#{object_index}"
    sound.client = Client::CommandLine
    sound
  end

  SONIC_PI = SonicPi.new

  def self.play_sound(file_name)
    SONIC_PI.run("run_file '#{FileUtils.pwd}/#{file_name}.rb'")
  end

  def self.stop_sound
    SONIC_PI.stop
  end

  attr_accessor :fitness,
                :name,
                :client

  alias rating= fitness=
  alias rating fitness

  REPLAY_PAUSE = 5

  def evaluate!
    create_sound_file
    play_sound(sound_file_name)
    client.display_sound_name(name)
    client.display_rating_prompt
    self.rating = client.get_rating(REPLAY_PAUSE, replay_block)
    stop_sound
    client.accept_rating(rating)
  end

  def replay_block
    lambda do
      stop_sound
      play_sound(sound_file_name)
    end
  end

  BEATS_COUNT = 8

  def create_sound_file
    sonic_pi_code = ''
    BEATS_COUNT.times do |beat_count|
      @genes.each do |gene_class|
        expression = gene_class.expression(beat_count)
        sonic_pi_code << expression if expression
      end
      sonic_pi_code << "sleep 0.3\n"
    end
    File.write("./#{sound_file_name}.rb", sonic_pi_code)
  end

  def sound_file_name
    "sounds/#{population.name}_#{name}"
  end

  def evolvable_progress(info = nil)
    play_sound(sound_file_name)
    sound_parent_1_name = 'sound1'
    client.display_sound_parent_1(sound_parent_1_name)
    stop_sound
    sleep 0.1
    # TODO: play sound parent 2
    sound_parent_2_name = 'sound2'
    client.display_sound_parent_2(sound_parent_2_name)
    stop_sound
  end

  def play_sound(file_name)
    self.class.play_sound(file_name)
  end

  def stop_sound
    self.class.stop_sound
  end
end
