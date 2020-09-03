# Bunter: A butler for Alfred 🕴

## Installation

Add this line to your application's Gemfile:

```ruby
gem "bunter", github: "zgracem/bunter"
```

And then execute:

```sh
bundle install
```

Or download [the latest release](https://github.com/zgracem/bunter/releases),
and then:

```sh
cd ~/Downloads # or wherever you saved the file
gem install bunter-0.1.0.gem
```

## Usage

### Alfred → YAML

First, export your snippets collection as an `.alfredsnippets` file through the
Alfred Preferences GUI:

![Right-click on it in the 'Collections' pane and select 'Export…'][img]

[img]: https://raw.githubusercontent.com/zgracem/bunter/main/doc/alfred-export-example.png?raw=true

Then use Bunter to decompile the exported snippets into YAML (on stdout):

```sh
bunter ./Emoji.alfredsnippets > ./src/emoji.yaml
```

### YAML → Alfred

First, prepare a YAML file according to the syntax reference below.

Then use Bunter to compile the YAML into an `.alfredsnippets` file:

```sh
$ bunter ./src/snippets.yaml
/Users/zgm/Desktop/My_Collection.alfredsnippets
```

Find the file on your desktop and double-click it.

Alfred will take care of the rest!

## YAML syntax example

```yaml
---
name:           "Emoji"
image:          "images/emoji.png"
prefix:         ":;"
suffix:         ":"
snippets:
- keyword:      "100"
  snippet:      "💯"
  name:         "100% emoji"
  uuid:         "C7462899-A668-4815-AB29-0A9A0521E13A"
  auto_expand:  true
- keyword:      "alien"
  snippet:      "👽"
  name:         "Alien emoji"
  uuid:         "4E95D4E7-508C-4FF0-9C20-87652C4A0888"
  auto_expand:  true
...
```

* `image` is an optional path to a PNG image, relative to the YAML file.
* `prefix` and `suffix` are also optional.
* For each item under `snippets`:
    * `uuid` is optional: Bunter will automatically add UUIDs to snippets which
      lack them.
    * `auto_expand` is optional, and defaults to `false`.

A sample file is also provided in [`data/`][data].

[data]: https://github.com/zgracem/bunter/tree/main/data

## Development

After checking out this repo, run `bin/setup` to install dependencies.

Run `bin/console` for an interactive prompt that will allow you to experiment.

### Documentation

Bunter is documented using [YARD].

* `rake docs:build` will write full documentation for Bunter to `doc/yard`.
* `rake docs:cleanup` will remove `doc/yard` entirely.
* `rake docs:server` will start a documentation server at `localhost:8808`.

[Yard]: https://github.com/lsegal/yard

### Contributing

Bug reports and pull requests are welcome on Bunter's [GitHub] repo.

Everyone interacting with this project must follow the [code of conduct][cc].

[GitHub]: https://github.com/zgracem/bunter
[cc]: https://github.com/zgracem/bunter/blob/main/CODE_OF_CONDUCT.md
