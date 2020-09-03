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
gem install bunter-0.0.1.gem
```

## Usage

### Alfred → YAML

First, export your snippets collection as an `.alfredsnippets` file through the
Alfred Preferences GUI:

![Right-click on it in the 'Collections' pane and select 'Export…'][img]

[img]: ./doc/alfred-export-example.png?raw=true

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
name:         "Emoji"
image:        "images/emoji.png"
prefix:       ":"
suffix:       ":"
snippets:
- keyword:    "100"
  snippet:    "💯"
  name:       "100% emoji"
  uid:        "50677B02-641D-4372-B9B3-32F46A9BEE3D"
  auto_expand: true
...
```

* `image` is an optional path to a PNG image, relative to the YAML file.
* `prefix` and `suffix` are also optional.
* For each item in `snippets`, a `uid` is optional—Bunter automatically adds
  UIDs to snippets without them as part of the conversion process.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.
