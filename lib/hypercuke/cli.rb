require 'hypercuke/cli/parser'
require 'hypercuke/cli/builder'

module Hypercuke
  class CLI
    def self.exec(argv, opts = {})
      cli = new(argv, opts[:output_to])
      cli.run!
    end

    # NB: .bundler_present? is not covered by tests, because I can't
    # think of a reasonable way to test it.  PRs welcome.  :)
    def self.bundler_present?
      !! (`which bundle` =~ /\wbundle\w/) # parens are significant
    end

    def initialize(argv, output = nil, environment = ENV, kernel = Kernel)
      @argv        = argv
      @output      = output
      @environment = environment
      @kernel      = kernel
    end

    def run!
      output && output.puts(cucumber_command_for_display)
      new_env = environment.to_hash.merge({ Hypercuke::LAYER_NAME_ENV_VAR => layer_name })
      kernel.exec new_env, cucumber_command
    end

    def layer_name
      parser.layer_name
    end

    def cucumber_command
      prepend_bundler = self.class.bundler_present?
      builder.cucumber_command_line(prepend_bundler)
    end

    def cucumber_command_for_display
      "#{LAYER_NAME_ENV_VAR}=#{layer_name} #{cucumber_command}"
    end

    private
    attr_reader :argv, :output, :environment, :kernel

    def parser
      @parser ||= Hypercuke::CLI::Parser.new(argv)
    end

    def builder
      @builder ||= Hypercuke::CLI::Builder.new(parser.options)
    end
  end
end
