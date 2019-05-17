require 'evolvable_sound/version'
require 'evolvable_sound/sonic_pi_synthinfo'
require 'evolvable_sound/synth'
require 'evolvable_sound/sample'
require 'evolvable_sound/client/command_line'
require 'evolvable_sound/client/command_line_controller'
require 'evolvable'
require 'sonic_pi'

class EvolvableSound
  include Evolvable

  def self.compose_song(population_name)
    top_sound_file_paths = find_top_rated_sound_per_generation(population_name)
    song_code = ''
    top_sound_file_paths.each do |file_path|
      rating = file_name_meta_attrs(file_path)[:rating]
      song_code << File.read(file_path)
    end
    File.write("./songs/#{population_name}.rb", song_code)
  end

  def self.find_top_rated_sound_per_generation(population_name)
    sounds_generation_ratings = Hash.new { |hash, key| hash[key] = [] }
    Dir["#{FileUtils.pwd}/sounds/#{population_name}*.rb"].max_by do |file_path|
      file_meta_attrs = file_name_meta_attrs(file_path)
      rating = file_meta_attrs[:rating]
      generation = file_meta_attrs[:generation]
      sounds_generation_ratings[generation] << [rating, file_path]
    end
    top_sound_file_paths = []
    sounds_generation_ratings.each do |generation, sounds|
      top_rated_sound = sounds.max_by { |rating, _file_path| rating }
      sound_file_path = top_rated_sound[1]
      top_sound_file_paths[generation] = sound_file_path
    end
    top_sound_file_paths
  end

  def self.file_name_meta_attrs(file_path)
    file_name = file_path.split("evolvable_sound/sounds/").last
    file_name.tr!('.rb', '')
    population_name, class_name, generation, object_index, rating = file_name.split('_')
    { population_name: population_name,
      class_name: class_name,
      generation: generation.to_i,
      object_index: object_index.to_i,
      rating: rating.to_i }
  end

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
    8
  end

  def self.evolvable_evaluate!(bands)
    bands.each(&:evaluate!)
  end

  def self.evolvable_initialize(genes, population, object_index)
    sound = new
    sound.genes = genes
    sound.population = population
    sound.object_index = object_index
    sound.client = client
    sound
  end

  def self.client
    @client ||= Client::CommandLine
  end

  def self.client=(val)
    @client = val
  end

  def self.evolvable_before_crossover(population)
    parent_1, parent_2 = population.objects
    play_sound(parent_1.sound_file_rating_name)
    parent_1.client.display_sound_parent_1(parent_1.name)
    stop_sound
    sleep 0.1
    play_sound(parent_2.sound_file_rating_name)
    parent_2.client.display_sound_parent_2(parent_2.name)
    stop_sound
    sleep 0.3
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
                :client,
                :object_index

  alias rating= fitness=
  alias rating fitness

  REPLAY_PAUSE = 5

  def evaluate!
    create_sound_file
    play_sound(sound_file_name)
    client.display_sound(self)
    client.display_rating_prompt
    self.rating = client.get_rating(REPLAY_PAUSE, replay_block)
    stop_sound
    client.accept_rating(rating)
    FileUtils.mv("#{sound_file_name}.rb", "#{sound_file_rating_name}.rb")
  end

  def name
    @name ||= compute_name
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
    "sounds/#{population.name}_sound_#{population.generation_count}_#{object_index}"
  end

  def sound_file_rating_name
    "#{sound_file_name}_#{rating}"
  end

  def play_sound(file_name)
    self.class.play_sound(file_name)
  end

  def stop_sound
    self.class.stop_sound
  end

  private

  def compute_name
    char_index = 0
    name = +''
    gene_names = genes.map { |g| g.name.to_s }
    gene_names.each do |gene_name|
      char = gene_name[char_index]
      if char
        char_index += 1
      else
        char = gene_name[-1]
      end
      name << char
    end
    name
  end
end
