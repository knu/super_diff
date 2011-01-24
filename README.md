# SuperDiff

## What is this?

SuperDiff is a utility that helps you diff two complex data structures in Ruby, and gives you helpful output to show you exactly how the two data structures differ.

## How does it work?

Let's say we have two arrays. Array A looks like this:

    [
      "foo",
      ["bar", ["baz", "quux"]],
      "ying",
      ["blargh", "zing", "fooz", ["raz", ["vermouth", "eee", "ffff"]]]
    ]

Array B looks like this:

    [
      "foz",
      "bar",
      "ying",
      ["blargh", "gragh", 1, ["raz", ["ralston"]], ["foreal", ["zap"]]]
    ]

We want to know what the difference is between them, so we say:

    differ = SuperDiff::Differ.new
    data = differ.diff(a, b)
    stdout = StringIO.new
    reporter = SuperDiff::Reporter.new(stdout)
    reporter.report(data)

Differ#data takes two values and figures out the difference between them, returning a hash of data that represents this difference. If the two values are both arrays or hashes, this means descending into the values recursively and figuring out the difference between elements too. Reporter#report then takes the data generated by the Differ and formats it into a message, sending to the stream we've given. So if we read the StringIO here, we'll get this:

    Error: Arrays of same size but with differing elements.

    Expected: ["foo", ["bar", ["baz", "quux"]], "ying", ["blargh", "zing", "fooz", ["raz", ["vermouth", "eee", "ffff"]]]]
    Got: ["foz", "bar", "ying", ["blargh", "gragh", 1, ["raz", ["ralston"]], ["foreal", ["zap"]]]]

    Breakdown:
    - *[0]: Differing strings.
      - Expected: "foo"
      - Got: "foz"
    - *[1]: Values of differing type.
      - Expected: ["bar", ["baz", "quux"]]
      - Got: "bar"
    - *[3]: Arrays of same size but with differing elements.
      - *[1]: Differing strings.
        - Expected: "zing"
        - Got: "gragh"
      - *[2]: Values of differing type.
        - Expected: "fooz"
        - Got: 1
      - *[3]: Arrays of same size but with differing elements.
        - *[1]: Arrays of differing size and elements.
          - *[0]: Differing strings.
            - Expected: "vermouth"
            - Got: "ralston"
          - *[1]: Expected to be present, but missing "eee".
          - *[2]: Expected to be present, but missing "ffff".
    - *[4]: Expected to not be present, but found ["foreal", ["zap"]].

## Why did you make it?

For testing, specifically with RSpec. For instance, say you're doing a simple equality test, but between two complex data structures:

    complex_data_structure.should == another_complex_data_structure

Now, RSpec (at least RSpec 2) *does* give you a difference between the two data structures, but all it really does is call `complex_data_structure.pretty_inspect` and `another_complex_data_structure.pretty_inspect` and then uses Diff::LCS to take the unified diff between the two strings (as though they were text files). It's not a terrible solution, but it's naive -- it doesn't know anything about the data structures involved, so you have to do a bit of work to read the unified diff output and then apply it to the data. I think this process could be made easier.

## Can I use it?

Sure. Be aware that this is kind of proof-of-concept at the moment, so things will probably change in the future, like the API or even the name of the project. If that's okay with you, feel free to try it out.

## What are your plans for this?

Check out the [issue tracker](http://github.com/mcmire/super_diff/issues). If you have an idea, add an issue and I'll take a look.

## Can I hack on it?

Totally! Here's what you need to do to get going:

* If you use RVM, `rvm install 1.9.2` with a "super_diff" gemset. There's an .rvmrc so when you drop into the repo (assuming you've cloned it) you'll be in the gemset automatically.

  If you aren't using RVM, you'll still want to install 1.9. It won't be required to actually use SuperDiff in production, but it's important for testing since hashes are ordered in 1.9 and therefore the output the Reporter generates is done so in a guaranteed order.
* Install Bundler, then `bundle install` (this is only for development; SuperDiff proper doesn't require any dependencies).

If you're contributing an idea or fixing a bug:

* Add tests. I'm using RSpec, so you can run all tests with `rake spec`.
* Make a branch, send me a pull request, and I'll take a look at it.

## Copyright/License

&copy; 2011 Elliot Winkler. The code here is under no license; you're free to do whatever you want with it. If you do end up using it, an attached courtesy would be appreciated.

## Contact

* **Email:** <elliot.winkler@gmail.com>
* **Twitter:** [@mcmire](http://twitter.com/mcmire)
* **Blog:** <http://lostincode.net>