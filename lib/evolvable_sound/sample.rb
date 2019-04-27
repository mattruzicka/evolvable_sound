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

        def arg_keys
          @arg_keys ||= arg_defaults.keys
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

  def self.randomize_args
    randomized_args = {}

    { amp: lambda { rand },
      amp_slide: lambda { nil },
      amp_slide_shape: lambda { nil },
      amp_slide_curve: lambda { nil },
      pre_amp: lambda { nil },
      pre_amp_slide: lambda { nil },
      pre_amp_slide_shape: lambda { nil },
      pre_amp_slide_curve: lambda { nil },
      pan: lambda { nil },
      pan_slide: lambda { nil },
      pan_slide_shape: lambda { nil },
      pan_slide_curve: lambda { nil },
      attack: lambda { nil },
      decay: lambda { nil },
      sustain: lambda { nil },
      release: lambda { nil },
      lpf: lambda { nil },
      lpf_slide: lambda { nil },
      lpf_slide_shape: lambda { nil },
      lpf_slide_curve: lambda { nil },
      lpf_attack: lambda { nil },
      lpf_decay: lambda { nil },
      lpf_sustain: lambda { nil },
      lpf_release: lambda { nil },
      lpf_init_level: lambda { nil },
      lpf_attack_level: lambda { nil },
      lpf_decay_level: lambda { nil },
      lpf_sustain_level: lambda { nil },
      lpf_release_level: lambda { nil },
      lpf_env_curve: lambda { nil },
      lpf_min: lambda { nil },
      lpf_min_slide: lambda { nil },
      lpf_min_slide_shape: lambda { nil },
      lpf_min_slide_curve: lambda { nil },
      hpf: lambda { nil },
      hpf_slide: lambda { nil },
      hpf_slide_shape: lambda { nil },
      hpf_slide_curve: lambda { nil },
      hpf_attack: lambda { nil },
      hpf_sustain: lambda { nil },
      hpf_decay: lambda { nil },
      hpf_release: lambda { nil },
      hpf_init_level: lambda { nil },
      hpf_attack_level: lambda { nil },
      hpf_decay_level: lambda { nil },
      hpf_sustain_level: lambda { nil },
      hpf_release_level: lambda { nil },
      hpf_env_curve: lambda { nil },
      hpf_max: lambda { nil },
      hpf_max_slide: lambda { nil },
      hpf_max_slide_shape: lambda { nil },
      hpf_max_slide_curve: lambda { nil },
      attack_level: lambda { nil },
      decay_level: lambda { nil },
      sustain_level: lambda { nil },
      env_curve: lambda { nil },
      rate: lambda { nil },
      start: lambda { nil },
      finish: lambda { nil },
      norm: lambda { nil },
      pitch: lambda { nil },
      pitch_slide: lambda { nil },
      pitch_slide_shape: lambda { nil },
      pitch_slide_curve: lambda { nil },
      window_size: lambda { nil },
      window_size_slide: lambda { nil },
      window_size_slide_shape: lambda { nil },
      window_size_slide_curve: lambda { nil },
      pitch_dis: lambda { nil },
      pitch_dis_slide: lambda { nil },
      pitch_dis_slide_shape: lambda { nil },
      pitch_dis_slide_curve: lambda { nil },
      time_dis: lambda { nil },
      time_dis_slide: lambda { nil },
      time_dis_slide_shape: lambda { nil },
      time_dis_slide_curve: lambda { nil },
      compress: lambda { nil },
      threshold: lambda { nil },
      threshold_slide: lambda { nil },
      threshold_slide_shape: lambda { nil },
      threshold_slide_curve: lambda { nil },
      clamp_time: lambda { nil },
      clamp_time_slide: lambda { nil },
      clamp_time_slide_shape: lambda { nil },
      clamp_time_slide_curve: lambda { nil },
      slope_above: lambda { nil },
      slope_above_slide: lambda { nil },
      slope_above_slide_shape: lambda { nil },
      slope_above_slide_curve: lambda { nil },
      slope_below: lambda { nil },
      slope_below_slide: lambda { nil },
      slope_below_slide_shape: lambda { nil },
      slope_below_slide_curve: lambda { nil },
      relax_time: lambda { nil },
      relax_time_slide: lambda { nil },
      relax_time_slide_shape: lambda { nil },
      relax_time_slide_curve: lambda { nil } }.each do |sample_arg, lambda|
        value = lambda.call
        randomized_args[sample_arg] = value if value
    end
    randomized_args
  end
end
