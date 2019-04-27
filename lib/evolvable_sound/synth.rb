class EvolvableSound::Synth
  def self.define_evolvable_genes
    classes.each do |klass|
      klass.class_eval do
        def expression(beat)
          @expressions ||= initialize_expressions
          return if @expressions[beat].empty?

          beat_expression = @expressions[beat].dup
          note = beat_expression.delete(:note) || arg_default(:note) || 1
          "use_synth :#{synth_name}\n" \
          "play #{note}, #{beat_expression}\n"
        end

        def arg_keys
          @arg_keys ||= arg_defaults.keys
        end

        def initialize_expressions
          Hash.new do |hash, key|
            EvolvableSound::Synth.randomize_args(args: arg_keys)
          end
        end
      end
    end
  end

  def self.classes
    @classes ||= lookup_classes
  end

  IGNORED_SYNTH_CLASSES = [SonicPi::Synths::ModTri, # Breaks with { mod_range_slide_shape: 6 } option
                           SonicPi::Synths::SoundInStereo,
                           SonicPi::Synths::SoundIn]

  def self.lookup_classes
    SonicPi::Synths::SynthInfo.synth_infos.each_value.map do |synth|
      next unless synth.is_a?(SonicPi::Synths::SonicPiSynth) && synth.user_facing?

      synth_class = synth.class
      synth_class unless IGNORED_SYNTH_CLASSES.include?(synth_class)
    end.compact
  end

  def self.default_args
    @default_args = classes.inject({}) { |h, c| c.merge!(k.new.arg_defaults) }
  end

  def self.randomize_args(args: [],
                          min_note: 30,
                          max_note: 100,
                          max_attack: 0.5,
                          max_decay: 0.5,
                          max_sustain: 0.5,
                          max_release: 0.5,
                          max_attack_level: 0.5,
                          max_decay_level: 0.5,
                          max_sustain_level: 0.5,
                          max_slide: 0.5,
                          mod_range: 20)
    randomized_args = {}
    { note: lambda { rand(min_note..max_note) },
      note_slide: lambda { rand(0.0..max_slide) },
      note_slide_shape: lambda { [0, 1, 2, 3, 4, 6, 7, 8].sample },
      note_slide_curve: lambda { rand(-1..1.0) },
      amp: lambda { rand },
      amp_slide: lambda { rand(0.0..max_slide) },
      amp_slide_shape: lambda { rand(1..7) },
      amp_slide_curve: lambda { rand(-1..1.0) },
      pan: lambda { rand(-1..1.0) },
      pan_slide: lambda { rand(0.0..max_slide) },
      pan_slide_shape: lambda { rand(1..7) },
      pan_slide_curve: lambda { rand(-1..1.0) },
      attack: lambda { rand(0.0..max_attack) },
      decay: lambda { rand(0.0..max_decay) },
      sustain: lambda { rand(0.0..max_sustain) },
      release: lambda { rand(0.0..max_release) },
      attack_level: lambda { rand(0.0..max_attack_level) },
      decay_level: lambda { rand(0.0..max_decay_level) },
      sustain_level: lambda { rand(0.0..max_sustain_level) },
      env_curve: lambda { [1, 3, 4, 6, 7].sample }, # there's a bug with 2
      cutoff: lambda { rand(0..130) },
      cutoff_slide: lambda { rand(0.0..max_slide) },
      cutoff_slide_shape: lambda { rand(1..7) },
      cutoff_slide_curve: lambda { rand(-1..1.0) },
      mod_phase: lambda { rand },
      mod_phase_slide: lambda { rand(0.0..max_slide) },
      mod_phase_slide_shape: lambda { rand(1..7) },
      mod_phase_slide_curve: lambda { rand(-1..1.0) },
      mod_range: lambda { rand(-mod_range..mod_range) },
      mod_range_slide: lambda { rand(0.0..max_slide) },
      mod_range_slide_shape: lambda { rand(1..7) },
      mod_range_slide_curve: lambda { rand(-1..1.0) },
      mod_pulse_width: lambda { rand },
      mod_pulse_width_slide: lambda { rand(0.0..max_slide) },
      mod_pulse_width_slide_shape: lambda { rand(1..7) },
      mod_pulse_width_slide_curve: lambda { rand(-1..1.0) },
      mod_phase_offset: lambda { rand },
      mod_invert_wave: lambda { [0, 1].sample },
      mod_wave: lambda { rand(0..3) },
      detune: lambda { rand },
      detune_slide: lambda { rand(0.0..max_slide) },
      detune_slide_shape: lambda { rand(1..7) },
      detune_slide_curve: lambda { rand(-1..1.0) },
      divisor: lambda { rand(100) },
      divisor_slide: lambda { rand(0.0..max_slide) },
      divisor_slide_shape: lambda { rand(1..7) },
      divisor_slide_curve: lambda { rand(-1..1.0) },
      depth: lambda { rand(min_note..max_note) },
      depth_slide: lambda { rand(0.0..max_slide) },
      depth_slide_shape: lambda { rand(1..7) },
      depth_slide_curve: lambda { rand(-1..1.0) },
      pulse_width: lambda { rand },
      pulse_width_slide: lambda { rand(0.0..max_slide) },
      pulse_width_slide_shape: lambda { rand(1..7) },
      pulse_width_slide_curve: lambda { rand(-1..1.0) },
      dpulse_width: lambda { rand },
      dpulse_width_slide: lambda { rand(0.0..max_slide) },
      dpulse_width_slide_shape: lambda { rand(1..7) },
      dpulse_width_slide_curve: lambda { rand(-1..1.0) },
      sub_amp: lambda { rand },
      sub_amp_slide: lambda { rand(0.0..max_slide) },
      sub_amp_slide_shape: lambda { rand(1..7) },
      sub_amp_slide_curve: lambda { rand(-1..1.0) },
      sub_detune: lambda { rand },
      sub_detune_slide: lambda { rand(0.0..max_slide) },
      sub_detune_slide_shape: lambda { rand(1..7) },
      sub_detune_slide_curve: lambda { rand(-1..1.0) },
      res: lambda { rand },
      res_slide: lambda { rand(0.0..max_slide) },
      res_slide_shape: lambda { rand(1..7) },
      res_slide_curve: lambda { rand(-1..1.0) },
      noise: lambda { rand(0..4) },
      norm: lambda { [0, 1].sample },
      detune1: lambda { rand },
      detune1_slide: lambda { rand(0.0..max_slide) },
      detune1_slide_shape: lambda { rand(1..7) },
      detune1_slide_curve: lambda { rand(-1..1.0) },
      detune2: lambda { rand },
      detune2_slide: lambda { rand(0.0..max_slide) },
      detune2_slide_shape: lambda { rand(1..7) },
      detune2_slide_curve: lambda { rand(-1..1.0) },
      ring: lambda { rand(0.1..50) },
      room: lambda { rand(0.1..300) },
      reverb_time: lambda { rand(0..1000) },
      vel: lambda { rand },
      hard: lambda { rand },
      stereo_width: lambda { rand },
      noise_amp: lambda { rand },
      max_delay_time: lambda { rand(0.125..1) },
      pluck_decay: lambda { rand(1..100) },
      coef: lambda { rand(-1..1) },
      vibrato_rate: lambda { rand(0..20) },
      vibrato_rate_slide_shape: lambda { rand(1..7) },
      vibrato_rate_slide_curve: lambda { rand(-1..1.0) },
      vibrato_depth: lambda { rand(0..5)  },
      vibrato_depth_slide_shape: lambda { rand(1..7) },
      vibrato_depth_slide_curve: lambda { rand(-1..1.0) },
      vibrato_delay: lambda { rand(0..100) },
      vibrato_onset: lambda { rand(0..100) },
      cutoff_min: lambda { rand(0..130) },
      cutoff_min_slide: lambda { rand(0.0..max_slide) },
      cutoff_min_slide_shape: lambda { rand(1..7) },
      cutoff_min_slide_curve: lambda { rand(-1..1.0) },
      cutoff_attack: lambda { rand },
      cutoff_decay: lambda { rand },
      cutoff_sustain: lambda { rand },
      cutoff_release: lambda { rand },
      cutoff_attack_level: lambda { rand },
      cutoff_decay_level: lambda { rand },
      cutoff_sustain_level: lambda { rand },
      wave: lambda { [0, 1, 2].sample },
      note_resolution: lambda { rand },
      width: lambda { [0, 1, 2].sample },
      phase: lambda { rand(0.1..5) },
      phase_slide: lambda { rand(0.0..max_slide) },
      phase_slide_shape: lambda { rand(1..7) },
      phase_slide_curve: lambda { rand(-1..1.0) },
      phase_offset: lambda { rand },
      invert_wave: lambda { [0, 1].sample },
      range: lambda { rand(0..90) },
      range_slide: lambda { rand(0.0..max_slide) },
      range_slide_shape: lambda { rand(1..7) },
      range_slide_curve: lambda { rand(-1..1.0) },
      disable_wave: lambda { [0, 1].sample },
      freq_band: lambda { rand(0..15) },
      freq_band_slide: lambda { rand(0.0..max_slide) },
      freq_band_slide_shape: lambda { rand(1..7) },
      freq_band_slide_curve: lambda { rand(-1..1.0) } }.each do |arg, lambda|
        next unless args.include?(arg)

        value = lambda.call
        randomized_args[arg] = value if value
    end
    randomized_args
  end
end
