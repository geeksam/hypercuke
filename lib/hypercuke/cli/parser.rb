module Hypercuke
  class CLI

    # I extract relevant information from a 'hcu' command line, namely:
    # - layer name
    # - mode, if present, defaulting to 'ok'
    # - other args to pass along to Cucumber
    class Parser
      attr_reader :options
      def initialize(hcu_command)
        @tokens  = tokenize(hcu_command)
        @options = Hash.new

        parse_options
      end

      def layer_name
        options[:layer_name]
      end

      private
      attr_reader :tokens

      def tokenize(input)
        args =
          case input
          when Array  ; input
          when String ; input.split(/\s+/) # That's 4 years of CS education right there, baby
          else fail "Don't know how to parse #{input.inspect}"
          end
        args.compact
      end

      def parse_options
        ignore_hcu
        set_layer_name
        set_mode_if_present
        set_profile_if_present
        set_other_args
      end

      # We might get the 'hcu' command name itself; just drop it on the floor
      def ignore_hcu
        tokens.shift if tokens.first =~ /\bhcu$/i
      end

      # This is the only required argument.
      # TODO: Validate this against the list of known layers?
      #       ^ Would require loading local app's hypercuke config.
      #       ^ Would require allowing local app to *have* hypercuke config.
      def set_layer_name
        fail "Layer name is required" if tokens.empty?
        options[:layer_name] = tokens.shift
      end

      def set_mode_if_present
        unless tokens.first =~ /^-/
          options[:mode] = tokens.shift
        end
      end

      def set_profile_if_present
        if profile_index = ( tokens.index('--profile') || tokens.index('-p') )
          tokens.delete_at(profile_index) # don't care
          options[:profile] = tokens.delete_at(profile_index)
        end
      end

      def set_other_args
        options[:other_args] = Array.new.tap do |rest|
          rest << tokens.shift until tokens.empty?
        end
      end
    end

  end
end
