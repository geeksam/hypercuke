# Hypercuke

Hypercuke helps you use Cucumber to do BDD at multiple layers of your
application, and gently nudges you into writing your scenarios in
high-level terms that your users can understand.

## Why?

Because TATFT.

### Okay, But Why Cucumber?

Cucumber is a great way to write acceptance tests that are also, by
definition, integration tests.  Each scenario defines a "walking
skeleton" (I've also heard "tracer bullet") -- one complete path through
the system from top to bottom, describing one feature that an end user
actually cares about.

### So Why Doesn't Everyone Do This Already?

The traditional Rails approach of using Cucumber to test an app from a
browser has some pitfalls:

* In the short term, sometimes there's a LOT of new functionality to
  define, and you spend days or weeks just getting one scenario to pass.
  This can suck the morale right out of you.

More importantly, Cucumber has some long-term pitfalls:

* Having all your tests fire up a web browser and exercise the web
  application gets really really slow (especially when every! single!
  test! starts with "Given I am logged in as a normal user").

* More subtly, the implicit assumption that "Cucumber ==> web browser"
  makes it too easy for knowledge of the web UI to creep into tests --
  and, as the Cucumber community has already learned (see <a
  href="http://aslakhellesoy.com/post/11055981222/the-training-wheels-came-off">The
  Training Wheels Came Off</a>), this can lead to slow, brittle tests.

* Cucumber tutorials tend to show you step definitions that combine a
  regular expression with an associated block of code.  Then they say
  "TADA!" and wander off, leaving users with the impression that *that's
  where all their code is supposed to go*.  Because everything is in a
  flat namespace, this tends to turn into... well, PHP.  I've seen
  projects with thousands of lines of horrible procedural code in deeply
  interdependent step definitions that resist refactoring.  In one
  particularly memorable instance, I actually helped write a 50-line
  step definitions with a parameter named "destroy_the_earth".

### Why Hypercuke?

Hypercuke's core idea is a clever way of using Cucumber tags.  By
swapping out different adapters for your step definitions, you can write
a scenario once, tag it appropriately, and then execute that scenario to
test any or all of:

* a fast core layer of plain old Ruby objects,
* ActiveRecord models,
* some <a
  href="http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html">Gourmet
  Service Objects</a>,
* an API if you have one,
* the UI,
* or any other layer that's meaningful to you.

Hypercuke directly addresses each of the pain points described above:

* By starting off at a low layer, you can use your Cucumber scenario as
  a short-span integration test that's just wrapped around a few simple
  objects.  Once you're satisfied with how that works, you can move up
  to a higher level of abstraction.  If a scenario is a "walking
  skeleton", Hypercuke lets you start by building the skeleton just up
  to the knees, then up to the base of the spine, and so on.

* Just because your tests are in Cucumber doesn't mean they have to be
  slow.  I originally developed Hypercuke because I wanted to describe
  all of my features using Gherkin, but only test one or two "golden
  path" scenarios through a web browser.  Scenarios to describe boundary
  cases, exceptions, or variations can run against a lower layer of the
  application, which can have as much or as little overhead as makes
  sense for each scenario.

* Because my scenarios might run at varying levels of abstraction, I
  write them in interface-agnostic language.  (For example, I'll write
  "I view the list of widgets" instead of "I go to /widgets".)  And if I
  forget, the cognitive dissonance when I write the step definitions
  very quickly reminds me to use more generic language.  This helps me
  write tests at a high level of abstraction, and it also helps keep me
  focused on *why* I'm writing this feature, so I don't get lost
  building a gold-plated automated yak-shaving factory.

* Finally, Hypercuke provides *just enough* structure for you to write
  reusable step definitions.  Inside the regular-expression-plus-block
  that Cucumber gives you, you write the bare minimum amount of code you
  need to translate from Gherkin into a Ruby message, and then you send
  that message to a step adapter that does the work.  Step adapters are
  Ruby objects, which means you can use all of your Ruby fu to keep your
  code organized.

## How?

TODO: continue here :D

## About the Name

I started out with the concept of "layers", so this gem was originally
going to be called "cucumber-parfait".  But as I worked through it, I
kept visualizing things using two-dimensional matrices, which kept
moving around in my brain as I thought about them... and that reminded
me of visualizations of a hypercube.  Ergo, Hypercuke.

## Installation

Add this line to your application's Gemfile:

    gem 'hypercuke'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hypercuke

## Usage

Obviously I have some more writing to do, but you'll need to add this
line somewhere in your application's Cucumber environment (this is
usually somewhere in /features/support/):

    require 'hypercuke/cucumber_integration'

TODO: Write more detailed usage instructions

## Contributing

1. Fork it ( https://github.com/geeksam/hypercuke/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
