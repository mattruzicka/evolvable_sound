require 'evolvable_sound/version'
require 'evolvable_sound/sonic_pi_synthinfo'
require 'evolvable_sound/synth'
require 'evolvable_sound/sample'
require 'evolvable'
require 'sonic_pi'
require 'byebug'

class EvolvableSound
  include Evolvable

  def self.evolvable_gene_pool
    Synth.define_evolvable_genes
    Sample.define_evolvable_genes
    gene_pool = Synth.classes.map { |klass| [klass, 3] }
    gene_pool.concat Sample.classes.map { |klass| [klass, 1] }
    gene_pool
  end

  def self.evolvable_genes_count
    10
  end

  def self.evolvable_evaluate!(bands)
    bands.each(&:evaluate!)
  end

  def self.evolvable_initialize(genes, population, object_index)
    music = new
    music.genes = genes
    music.population = population
    music.name = "#{name}_#{population.generation_count}_#{object_index}"
    music
  end

  attr_accessor :fitness, :name

  SONIC_PI = SonicPi.new

  def evaluate!
    play
    print "rate 1-10: "
    rating = gets
    SONIC_PI.stop
    self.fitness = rating.to_i
  end

  BEATS_COUNT = 8

  def play
    sonic_pi_code = ''
    BEATS_COUNT.times do |beat_count|
      @genes.each do |gene_class|
        expression = gene_class.expression(beat_count)
        sonic_pi_code << expression if expression
      end
      sonic_pi_code << "sleep 0.3\n"
    end
    File.write("./#{sound_file_name}", sonic_pi_code)
    SONIC_PI.run("run_file '#{FileUtils.pwd}/#{sound_file_name}'")
  end

  def sound_file_name
    "sounds/#{name}.rb"
  end

  def evolvable_progress(info = nil)
    super(info)
    play
    print "Continue? "
    continue = gets
    SONIC_PI.stop
  end
end
