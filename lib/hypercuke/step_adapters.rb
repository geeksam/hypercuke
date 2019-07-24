module Hypercuke
  # Greetings, dear reader.  There's a lot going in this file, so it's
  # been organized in a more conversational style than most of the Ruby
  # code I write.  I hope it helps.

  # First things first:  the point of this entire file.
  #
  # Should you find yourself in possession of a [topic, layer] name
  # pair, this method allows you to redeem it for VALUABLE PRIZES!  (And
  # by "valuable prizes", I mean "a reference to a step adapter class,
  # if one has already been defined.")
  #
  # This method (on Hypercuke itself) is but a facade...
  def self.step_adapter_class(topic_name, layer_name)
    topic_module = StepAdapters.fetch_topic_module(topic_name)
    topic_module.fetch_step_adapter(layer_name)
  end

  # We start out with a namespace for step adapters.  As new step
  # adapter classes are created (see Hypercuke::AdapterDefinition), they
  # will be assigned to constants in this module's namespace (so that
  # they can have human-friendly names when something goes wrong and
  # #inspect gets called on them).
  #
  # Class names will be of the form:
  # Hypercuke::StepAdapters::<TopicName>::<LayerName>
  module StepAdapters
    extend self # BTW, I hate typing "self." in modules.

    # We'll get to what makes a topic module special in a moment,
    # but here's how we fetch one:
    def fetch_topic_module(topic_name)
      # FIXME: cyclomatic complexity
      Hypercuke.topics.validate(topic_name) do
        fail TopicNotDefinedError, "Topic not defined: #{topic_name}"
      end
      validate_topic_module \
        begin
          MiniInflector.constantize topic_name, self
        rescue NameError => e
          raise Hypercuke::TopicNotDefinedError.wrap(e)
        end
    end

    private

    def validate_topic_module(candidate)
      return candidate if candidate.kind_of?(::Hypercuke::TopicModule)
      fail Hypercuke::TopicNotDefinedError
    end
  end

  # So, a TopicModule is (a) a namespace for holding step adapters, and
  # (b) a slightly specialized type of Module that knows enough to be
  # able to fetch step adapters.
  class TopicModule < Module
    def fetch_step_adapter(layer_name)
      # FIXME: cyclomatic complexity
      Hypercuke.layers.validate(layer_name) do
        fail LayerNotDefinedError, "Layer not defined: #{layer_name}"
      end
      validate_step_adapter \
        begin
          MiniInflector.constantize layer_name, self
        rescue NameError => e
          raise Hypercuke::StepAdapterNotDefinedError.wrap(e)
        end
    end

    private

    def validate_step_adapter(candidate)
      return candidate if candidate.kind_of?(Class) && candidate.ancestors.include?(::Hypercuke::StepAdapter)
      fail Hypercuke::StepAdapterNotDefinedError
    end
  end

  # Okay.  That covers fetching step adapters once they've been defined.
  # Now let's talk about how we define new ones.

  module StepAdapters
    # Here's the entry point for the adapter definition API.  It's
    # entirely possible that a user might want to define their step
    # adapters in a re-entrant way (much like we've been reopening the
    # same modules and classes in this file), so this bit of the code
    # will either create a new step adapter, or return one that's
    # already been defined.
    def define(topic_name, layer_name)
      topic_module = define_topic_module(topic_name)
      step_adapter = topic_module.define_step_adapter( layer_name )
    end
  end

  # The next two bits follow this pattern:
  # 1) attempt to fetch the requested thing.
  # 2) if fetch fails, define and return it.

  module StepAdapters
    def define_topic_module(topic_name)
      fetch_topic_module(topic_name)
    rescue Hypercuke::TopicNotDefinedError
      const_name = MiniInflector.camelize(topic_name)
      const_set const_name, TopicModule.new
    end
  end

  class TopicModule < Module
    def define_step_adapter(layer_name)
      fetch_step_adapter(layer_name)
    rescue Hypercuke::StepAdapterNotDefinedError
      const_name = MiniInflector.camelize(layer_name)
      const_set const_name, Class.new(StepAdapter)
    end
  end

  # One final bit of business before we go: when testing code that
  # defines classes and binds them to constants, it is occasionally
  # useful to reset to a blank slate.
  module StepAdapters
    def clear
      constants.each do |c|
        remove_const c
      end
    end
  end
end
