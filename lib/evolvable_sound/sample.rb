class EvolvableSound::Sample
  def self.define_evolvable_genes
    SonicPi::Synths::MonoPlayer.all_samples.each do |sample_name|
      class_name = sample_name.to_s.split('_').map(&:capitalize).join
      evolvable_sample_class = Class.new(Object) do
        def expression(beat)
          @expressions ||= initialize_expressions
          return if @expressions[beat].empty?

          beat_expression = @expressions[beat]
          "sample :#{sample_name}, #{beat_expression}\n"
        end

        def initialize_expressions
          Hash.new do |hash, key|
            EvolvableSound::Sample.randomize_args
          end
        end
      end
      klass = EvolvableSound::Sample.const_set(class_name, evolvable_sample_class)
      klass.send(:define_method, :sample_name) { sample_name }
      classes << klass
    end
  end

  def self.classes
    @classes ||= []
  end

  def self.randomize_args(min_amp: 0.01,
                          max_amp: 10.0,
                          max_attack: 0.5,
                          max_decay: 0.5,
                          max_sustain: 0.5,
                          max_release: 0.5,
                          max_attack_level: 3,
                          max_decay_level: 3,
                          max_sustain_level: 3,
                          max_filter_level: 130,
                          min_rate: -5,
                          max_rate: 5,
                          max_slide: 0.5)
    randomized_args = {}

    { amp: lambda { rand(min_amp..max_amp) },
      amp_slide: lambda { rand(0.0..max_slide) },
      amp_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      amp_slide_curve: lambda { rand(-1..1.0) },
      pre_amp: lambda { rand(min_amp..max_amp) },
      pre_amp_slide: lambda { rand(0.0..max_slide) },
      pre_amp_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      pre_amp_slide_curve: lambda { rand(-1..1.0) },
      pan: lambda { rand(-1..1.0) },
      pan_slide: lambda { rand(0.0..max_slide) },
      pan_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      pan_slide_curve: lambda { rand(-1..1.0) },
      attack: lambda { rand(0.0..max_attack) },
      decay: lambda { rand(0.0..max_decay) },
      sustain: lambda { rand(0.0..max_sustain) },
      release: lambda { rand(0.0..max_release) },
      lpf: lambda { rand(0..max_filter_level) },
      lpf_slide: lambda { rand(0.0..max_slide) },
      lpf_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      lpf_slide_curve: lambda { rand(-1..1.0) },
      lpf_attack: lambda { rand(0.0..max_attack) },
      lpf_decay: lambda { rand(0.0..max_decay) },
      lpf_sustain: lambda { rand(0.0..max_sustain) },
      lpf_release: lambda { rand(0.0..max_release) },
      lpf_init_level: lambda { rand(0..max_filter_level) },
      lpf_attack_level: lambda { rand(0..max_filter_level) },
      lpf_decay_level: lambda { rand(0..max_filter_level) },
      lpf_sustain_level: lambda { rand(0..max_filter_level) },
      lpf_release_level: lambda { rand(0..max_filter_level) },
      lpf_env_curve: lambda { [1, 2, 3, 4, 6, 7].sample },
      lpf_min: lambda { rand(0..max_filter_level) },
      lpf_min_slide: lambda { rand(0.0..max_slide) },
      lpf_min_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      lpf_min_slide_curve: lambda { rand(-1..1.0) },
      hpf: lambda { rand(0..max_filter_level) },
      hpf_slide: lambda { rand(0.0..max_slide) },
      hpf_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      hpf_slide_curve: lambda { rand(-1..1.0) },
      hpf_attack: lambda { rand(0.0..max_attack) },
      hpf_sustain: lambda { rand(0.0..max_sustain) },
      hpf_decay: lambda { rand(0.0..max_decay) },
      hpf_release: lambda { rand(0.0..max_release) },
      hpf_init_level: lambda { rand(0..max_filter_level) },
      hpf_attack_level: lambda { rand(0..max_filter_level) },
      hpf_decay_level: lambda { rand(0..max_filter_level) },
      hpf_sustain_level: lambda { rand(0..max_filter_level) },
      hpf_release_level: lambda { rand(0..max_filter_level) },
      hpf_env_curve: lambda { [1, 2, 3, 4, 6, 7].sample },
      hpf_max: lambda { rand(0..max_filter_level) },
      hpf_max_slide: lambda { rand(0.0..max_slide) },
      hpf_max_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      hpf_max_slide_curve: lambda { rand(-1..1.0) },
      attack_level: lambda { rand(0.0..max_attack_level) },
      decay_level: lambda { rand(0.0..max_decay_level) },
      sustain_level: lambda { rand(0.0..max_sustain_level) },
      env_curve: lambda { [1, 3, 4, 6, 7].sample }, # there's a bug with 2
      rate: lambda { [rand(min_rate...0.0), rand(0.01..max_rate)].sample },
      start: lambda { rand },
      finish: lambda { rand },
      norm: lambda { [0, 1].sample },
      pitch: lambda { rand(-72.0..24) },
      pitch_slide: lambda { rand(0.0..max_slide) },
      pitch_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      pitch_slide_curve: lambda { rand(-1..1.0) },
      window_size: lambda { rand(0.00005..1.0) },
      window_size_slide: lambda { rand(0.0..max_slide) },
      window_size_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      window_size_slide_curve: lambda { rand(-1..1.0) },
      pitch_dis: lambda { rand },
      pitch_dis_slide: lambda { rand(0.0..max_slide) },
      pitch_dis_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      pitch_dis_slide_curve: lambda { rand(-1..1.0) },
      time_dis: lambda { rand },
      time_dis_slide: lambda { rand(0.0..max_slide) },
      time_dis_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      time_dis_slide_curve: lambda { rand(-1..1.0) },
      compress: lambda { [0, 1].sample },
      threshold: lambda { rand },
      threshold_slide: lambda { rand(0.0..max_slide) },
      threshold_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      threshold_slide_curve: lambda { rand(-1..1.0) },
      clamp_time: lambda { rand },
      clamp_time_slide: lambda { rand(0.0..max_slide) },
      clamp_time_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      clamp_time_slide_curve: lambda { rand(-1..1.0) },
      slope_above: lambda { rand },
      slope_above_slide: lambda { rand(0.0..max_slide) },
      slope_above_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      slope_above_slide_curve: lambda { rand(-1..1.0) },
      slope_below: lambda { rand },
      slope_below_slide: lambda { rand(0.0..max_slide) },
      slope_below_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      slope_below_slide_curve: lambda { rand(-1..1.0) },
      relax_time: lambda { rand },
      relax_time_slide: lambda { rand(0.0..max_slide) },
      relax_time_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      relax_time_slide_curve: lambda { rand(-1..1.0) } }.each do |sample_arg, lambda|
        next unless [true, false].sample # replace this with gene
        value = lambda.call
        randomized_args[sample_arg] = value if value
    end
    randomized_args
  end
end
