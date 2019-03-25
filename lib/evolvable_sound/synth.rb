class EvolvableSound::Synth
  def self.define_evolvable_synth_genes
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
            hash[key] = if [nil, true].sample
              {}
            else
              EvolvableSound::Synth.randomize_args(args: arg_keys)
            end
          end
        end
      end
    end
  end

  def self.classes
    @classes = lookup_classes
  end

  def self.lookup_classes
    SonicPi::Synths::SynthInfo.synth_infos.each_value.map do |synth|
      synth.class if synth.is_a?(SonicPi::Synths::SonicPiSynth) && synth.user_facing?
    end.compact
  end

  def self.default_args
    @default_args = classes.inject({}) { |h, c| c.merge!(k.new.arg_defaults) }
  end

  def self.randomize_args(args: [],
                          min_note: 0,
                          max_note: 120,
                          max_attack: 0.5,
                          max_decay: 0.5,
                          max_sustain: 0.5,
                          max_release: 0.5,
                          max_attack_level: 0.5,
                          max_decay_level: 0.5,
                          max_sustain_level: 0.5,
                          max_slide: 0.5)
    randomized_args = {}
    { note: lambda { rand(min_note..max_note) },
      note_slide: lambda { rand(0.0..max_slide) },
      note_slide_shape: lambda { rand(1..7) },
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
      cutoff: lambda { nil },
      cutoff_slide: lambda { rand(0.0..max_slide) },
      cutoff_slide_shape: lambda { rand(1..7) },
      cutoff_slide_curve: lambda { rand(-1..1.0) },
      mod_phase: lambda { nil },
      mod_phase_slide: lambda { rand(0.0..max_slide) },
      mod_phase_slide_shape: lambda { rand(1..7) },
      mod_phase_slide_curve: lambda { rand(-1..1.0) },
      mod_range: lambda { nil },
      mod_range_slide: lambda { rand(0.0..max_slide) },
      mod_range_slide_shape: lambda { rand(1..7) },
      mod_range_slide_curve: lambda { rand(-1..1.0) },
      mod_pulse_width: lambda { nil },
      mod_pulse_width_slide: lambda { rand(0.0..max_slide) },
      mod_pulse_width_slide_shape: lambda { rand(1..7) },
      mod_pulse_width_slide_curve: lambda { rand(-1..1.0) },
      mod_phase_offset: lambda { nil },
      mod_invert_wave: lambda { nil },
      mod_wave: lambda { nil },
      detune: lambda { nil },
      detune_slide: lambda { rand(0.0..max_slide) },
      detune_slide_shape: lambda { rand(1..7) },
      detune_slide_curve: lambda { rand(-1..1.0) },
      divisor: lambda { nil },
      divisor_slide: lambda { rand(0.0..max_slide) },
      divisor_slide_shape: lambda { rand(1..7) },
      divisor_slide_curve: lambda { rand(-1..1.0) },
      depth: lambda { nil },
      depth_slide: lambda { rand(0.0..max_slide) },
      depth_slide_shape: lambda { rand(1..7) },
      depth_slide_curve: lambda { rand(-1..1.0) },
      pulse_width: lambda { nil },
      pulse_width_slide: lambda { rand(0.0..max_slide) },
      pulse_width_slide_shape: lambda { rand(1..7) },
      pulse_width_slide_curve: lambda { rand(-1..1.0) },
      dpulse_width: lambda { nil },
      dpulse_width_slide: lambda { rand(0.0..max_slide) },
      dpulse_width_slide_shape: lambda { rand(1..7) },
      dpulse_width_slide_curve: lambda { rand(-1..1.0) },
      sub_amp: lambda { nil },
      sub_amp_slide: lambda { rand(0.0..max_slide) },
      sub_amp_slide_shape: lambda { rand(1..7) },
      sub_amp_slide_curve: lambda { rand(-1..1.0) },
      sub_detune: lambda { nil },
      sub_detune_slide: lambda { rand(0.0..max_slide) },
      sub_detune_slide_shape: lambda { rand(1..7) },
      sub_detune_slide_curve: lambda { rand(-1..1.0) },
      res: lambda { nil },
      res_slide: lambda { rand(0.0..max_slide) },
      res_slide_shape: lambda { rand(1..7) },
      res_slide_curve: lambda { rand(-1..1.0) },
      noise: lambda { nil },
      norm: lambda { nil },
      detune1: lambda { nil },
      detune1_slide: lambda { rand(0.0..max_slide) },
      detune1_slide_shape: lambda { rand(1..7) },
      detune1_slide_curve: lambda { rand(-1..1.0) },
      detune2: lambda { nil },
      detune2_slide: lambda { rand(0.0..max_slide) },
      detune2_slide_shape: lambda { rand(1..7) },
      detune2_slide_curve: lambda { rand(-1..1.0) },
      ring: lambda { nil },
      room: lambda { nil },
      reverb_time: lambda { nil },
      vel: lambda { nil },
      hard: lambda { nil },
      stereo_width: lambda { nil },
      noise_amp: lambda { nil },
      max_delay_time: lambda { nil },
      pluck_decay: lambda { nil },
      coef: lambda { nil },
      vibrato_rate: lambda { nil },
      vibrato_rate_slide_shape: lambda { rand(1..7) },
      vibrato_rate_slide_curve: lambda { rand(-1..1.0) },
      vibrato_depth: lambda { nil },
      vibrato_depth_slide_shape: lambda { rand(1..7) },
      vibrato_depth_slide_curve: lambda { rand(-1..1.0) },
      vibrato_delay: lambda { nil },
      vibrato_onset: lambda { nil },
      cutoff_min: lambda { nil },
      cutoff_min_slide: lambda { rand(0.0..max_slide) },
      cutoff_min_slide_shape: lambda { rand(1..7) },
      cutoff_min_slide_curve: lambda { rand(-1..1.0) },
      cutoff_attack: lambda { nil },
      cutoff_decay: lambda { nil },
      cutoff_sustain: lambda { nil },
      cutoff_release: lambda { nil },
      cutoff_attack_level: lambda { nil },
      cutoff_decay_level: lambda { nil },
      cutoff_sustain_level: lambda { nil },
      wave: lambda { nil },
      note_resolution: lambda { nil },
      width: lambda { nil },
      phase: lambda { nil },
      phase_slide: lambda { rand(0.0..max_slide) },
      phase_slide_shape: lambda { rand(1..7) },
      phase_slide_curve: lambda { rand(-1..1.0) },
      phase_offset: lambda { nil },
      invert_wave: lambda { nil },
      range: lambda { nil },
      range_slide: lambda { rand(0.0..max_slide) },
      range_slide_shape: lambda { rand(1..7) },
      range_slide_curve: lambda { rand(-1..1.0) },
      disable_wave: lambda { nil },
      pre_amp_slide: lambda { rand(0.0..max_slide) },
      hpf_slide: lambda { rand(0.0..max_slide) },
      lpf_slide: lambda { rand(0.0..max_slide) },
      pre_amp: lambda { nil },
      pre_amp_slide_shape: lambda { rand(1..7) },
      pre_amp_slide_curve: lambda { rand(-1..1.0) },
      hpf: lambda { nil },
      hpf_bypass: lambda { nil },
      hpf_slide_shape: lambda { rand(1..7) },
      hpf_slide_curve: lambda { rand(-1..1.0) },
      lpf: lambda { nil },
      lpf_bypass: lambda { nil },
      lpf_slide_shape: lambda { rand(1..7) },
      lpf_slide_curve: lambda { rand(-1..1.0) },
      force_mono: lambda { nil },
      invert_stereo: lambda { nil },
      limiter_bypass: lambda { nil },
      leak_dc_bypass: lambda { nil },
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
      lpf_min_slide: lambda { rand(0.0..max_slide) },
      lpf_min_slide_shape: lambda { rand(1..7) },
      lpf_min_slide_curve: lambda { rand(-1..1.0) },
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
      hpf_max_slide: lambda { rand(0.0..max_slide) },
      hpf_max_slide_shape: lambda { rand(1..7) },
      hpf_max_slide_curve: lambda { rand(-1..1.0) },
      rate: lambda { nil },
      start: lambda { nil },
      finish: lambda { nil },
      pitch: lambda { nil },
      pitch_slide: lambda { rand(0.0..max_slide) },
      pitch_slide_shape: lambda { rand(1..7) },
      pitch_slide_curve: lambda { rand(-1..1.0) },
      window_size: lambda { nil },
      window_size_slide: lambda { rand(0.0..max_slide) },
      window_size_slide_shape: lambda { rand(1..7) },
      window_size_slide_curve: lambda { rand(-1..1.0) },
      pitch_dis: lambda { nil },
      pitch_dis_slide: lambda { rand(0.0..max_slide) },
      pitch_dis_slide_shape: lambda { rand(1..7) },
      pitch_dis_slide_curve: lambda { rand(-1..1.0) },
      time_dis: lambda { nil },
      time_dis_slide: lambda { rand(0.0..max_slide) },
      time_dis_slide_shape: lambda { rand(1..7) },
      time_dis_slide_curve: lambda { rand(-1..1.0) },
      compress: lambda { nil },
      threshold: lambda { nil },
      threshold_slide: lambda { rand(0.0..max_slide) },
      threshold_slide_shape: lambda { rand(1..7) },
      threshold_slide_curve: lambda { rand(-1..1.0) },
      clamp_time: lambda { nil },
      clamp_time_slide: lambda { rand(0.0..max_slide) },
      clamp_time_slide_shape: lambda { rand(1..7) },
      clamp_time_slide_curve: lambda { rand(-1..1.0) },
      slope_above: lambda { nil },
      slope_above_slide: lambda { rand(0.0..max_slide) },
      slope_above_slide_shape: lambda { rand(1..7) },
      slope_above_slide_curve: lambda { rand(-1..1.0) },
      slope_below: lambda { nil },
      slope_below_slide: lambda { rand(0.0..max_slide) },
      slope_below_slide_shape: lambda { rand(1..7) },
      slope_below_slide_curve: lambda { rand(-1..1.0) },
      relax_time: lambda { nil },
      relax_time_slide: lambda { rand(0.0..max_slide) },
      relax_time_slide_shape: lambda { rand(1..7) },
      relax_time_slide_curve: lambda { rand(-1..1.0) },
      freq_band: lambda { nil },
      freq_band_slide: lambda { rand(0.0..max_slide) },
      freq_band_slide_shape: lambda { rand(1..7) },
      freq_band_slide_curve: lambda { rand(-1..1.0) },
      input: lambda { nil } }.slice(*args).each do |arg, lambda|
        value = lambda.call
        randomized_args[arg] = value if value
    end
    randomized_args
  end
end
