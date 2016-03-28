module Hypercuke
  class CLI

    # I take information extracted by the Parser and use it to build a
    # 'cucumber' command line
    class Builder
      def initialize(options)
        @options   = options
        @cuke_args = []
        build_cuke_args
      end

      def cucumber_command_line(prepend_bundler = false)
        cmd = prepend_bundler ? 'bundle exec ' : ''
        cmd << cuke_args.join(' ')
        cmd
      end

      private
      attr_reader :options, :cuke_args

      def build_cuke_args
        add_base_command
        add_layer_tag_for_mode
        add_profile_unless_already_present
        pass_through_all_other_args
      end

      def add_base_command
        cuke_args << 'cucumber'
      end

      def add_layer_tag_for_mode
        cuke_args << layer_tags_for_mode
      end

      def layer_tags_for_mode
        layer = options.fetch(:layer_name)
        mode  = [options[:mode].to_s.strip, 'ok'].reject {|s| s =~ /^\s*$/ }.first

        if 'ok' == mode
          "--tags @#{layer},@#{layer}_ok"
        else
          "--tags @#{layer}_#{mode}"
        end
      end

      def add_profile_unless_already_present
        if profile_specified?
          add_profile options[:profile]
        else
          if options[:mode] == 'wip'
            add_profile 'wip'
          end
        end
      end

      def profile_specified?
        options[:profile].to_s !~ /^\s*$/
      end

      def add_profile(profile_name)
        cuke_args << '--profile'
        cuke_args << profile_name
      end

      def pass_through_all_other_args
        cuke_args.concat( options[:other_args] )
      end
    end

  end
end
