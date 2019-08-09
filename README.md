# FA Rails

[![Gem Version](https://img.shields.io/gem/v/fa_rails.svg)](https://rubygems.org/gems/fa_rails)
[![Build Status](https://travis-ci.org/jfiander/fa_rails.svg)](https://travis-ci.org/jfiander/fa_rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/c5becd2d83b6de4b6392/maintainability)](https://codeclimate.com/github/jfiander/fa_rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c5becd2d83b6de4b6392/test_coverage)](https://codeclimate.com/github/jfiander/fa_rails/test_coverage)

A quick helper for using FontAwesome icons in Rails.

## Installation

**This gem is just the code for using FontAwesome in your Rails applications.**

You must still have your own FontAwesome Pro license, or install the
[Free](https://use.fontawesome.com/releases/v5.3.1/fontawesome-free-5.3.1-web.zip)
package.

Add the following to `config/application.rb`:

```ruby
require 'fa'
```

### Local Files

Copy the complete `js` and `css` directories from the
[web download](https://fontawesome.com/releases/5.2.0/web/download) into the
corresponding locations in your app, and ensure you correctly include all files.

### FontAwesome CDN

Go to the FontAwesome
[How to Use](https://fontawesome.com/how-to-use/on-the-web/setup/getting-started?using=web-fonts-with-css)
page and copy the appropriate CDN link tag.

You can also `include FA`, then use the built-in helper method in your layout:

```ruby
FA::Link.new(version: 'v5.3.1', integrity: 'sha384-some-key-here').safe
```

#### Free

```html
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-some-key-here" crossorigin="anonymous">
```

#### Pro

```html
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-some-key-here" crossorigin="anonymous">
```

**Be sure to also register each domain that will use this CDN link.**

## Usage

The `FA` module contains three main subclasses: `Icon`, `Span`, and `Layer`.
Argument formatting is consistent throughout.

`Icon` and `Span` are the units of this module. Both can be used individually.  
The first argument of each class's `new` method can be either a String/Symbol of
the name of the FontAwesome icon, or a Hash containing the complete
configuration for the object.

`Layer` is used to combine multiple units into a single end object. It takes
advantage of the Hash input style on `Icon` and `Span` to allow it to accept a
single configuration Array for the entire stack.

All three classes respond to two output methods: `raw` and `safe`.

- `raw` outputs the formatted string directly
- `safe` attempts to call `.html_safe` on the formatted string, if available

For convenience, each class also has a `p` method, which will create a new
instance, and return its `safe` output.

There is also a `Build` class that exposes a DSL to construct a `Layer`.

### Icon

A single FontAwesome icon.

#### Icon Arguments

```ruby
fa #=> String / Symbol – OR Hash
options #=> Hash
  style: Symbol # One of [:solid, :regular, :light, :brands], default :solid
  size: Integer # Stepped scaling factor

  css: String # Arbitrary CSS classes, space-delimited
  raw_css: Hash # Arbitrary raw CSS, as a hash of attributes and values
  fa: String # Arbitrary FA classes, space-delimited – each is automatically prefixed with `fa-`
  title: String #=> Tooltip text
  grow: Integer #=> Transform value – amount to grow by
  shrink: Integer #=> Transform value – amount to shrink by
  rotate: Integer #=> Transform value – amount to rotate by
  up: Integer #=> Translation value upward
  down: Integer #=> Translation value downward
  left: Integer #=> Translation value leftward
  right: Integer #=> Translation value rightward
```

### Span

A single FontAwesome span – counters or text labels – to be used in a Layer.

#### Span Arguments

```ruby
fa #=> String / Symbol – one of [:counter, :text] – OR Hash
text #=> String
options #=> Hash
  position: Symbol # Indicator of which corner to display on – one of [:tr, :tl, :br, :bl]

  css: String # Arbitrary CSS classes, space-delimited
  raw_css: Hash # Arbitrary raw CSS, as a hash of attributes and values
  fa: String # Arbitrary FA classes, space-delimited – each is automatically prefixed with `fa-`
  title: String #=> Tooltip text
  grow: Integer #=> Transform value – amount to grow by
  shrink: Integer #=> Transform value – amount to shrink by
  rotate: Integer #=> Transform value – amount to rotate by
  up: Integer #=> Translation value upward
  down: Integer #=> Translation value downward
  left: Integer #=> Translation value leftward
  right: Integer #=> Translation value rightward
```

### Layer

A stack of layered FontAwesome icons and spans.

#### Layer Arguments

```ruby
icons #=> Array of Hashes of individual icon/span configurations
title #=> String – tooltip text
grow #=> Integer – additional global scaling factor added to all objects in the stack
css #=> String – arbitrary CSS classes, space-delimited, applied to the layer stack
```

### Examples

```ruby
# Fixed-width lock icon
FA::Icon.p('lock', fa: 'fw')
#=> "<i class='fas fa-fw fa-lock fa-1x' style='' data-fa-transform='' title=''></i>"

# Duotone fire-alt icon with specified opacities
FA::Icon.p('fire-alt', style: :duotone, raw_css: { '--fa-primary-opacity' => '0.6', '--fa-secondary-opacity' => '0.4' })
#=> "<i class='fad fa-fire-alt fa-1x' style='--fa-primary-opacity: 0.4; --fa-secondary-opacity: 0.6;' data-fa-transform='' title=''></i>"

# You can also use this simplified configuration option for adding styles
#   This is reforatted and merged into :raw_css
#   Accepts either snake_case symbols or spear-case strings as keys, and strings or symbols as values
#   This is the easiest way to add primary/secondary styles for duotone icons
FA::Icon.p('fire-alt', style: :duotone, fa_styles: { primary_opacity: '0.6', secondary_opacity: '0.4', primary_color: :green, secondary_color: '#DD2200' })
#=> "<i class='fad fa-fire-alt fa-1x' style='--fa-primary-opacity: 0.6; --fa-secondary-opacity: 0.4; --fa-primary-color: green; --fa-secondary-color: #DD2200;' data-fa-transform='' title=''></i>"

# Counter span, with value 5
FA::Span.p('counter', 5)
#=> "<span class='fa-layers-counter ' style='' data-fa-transform=''>5</span>"

# Gray envelope icon with red exclamation mark overlayed, with tooltip 'Invalid email address'
FA::Layer.p([{ name: 'envelope', options: { css: :gray } }, { name: 'exclamation', options: { css: :red } }], title: 'Invalid email address')
#=> "<span class='icon fa-layers fa-stack fa-fw ' title='Invalid email address'>" \
#   "<i class='fas fa-stack-1x gray fa-envelope fa-1x' style='' data-fa-transform='grow-0' title='Invalid email address'></i>" \
#   "<i class='fas fa-stack-1x red fa-exclamation fa-1x' style='' data-fa-transform='grow-0' title='Invalid email address'></i>" \
#   "</span>"

# Blue envelope with red counter on the top left corner, with value 7
FA::Layer.p([{ name: 'envelope', options: { css: :blue } }, { name: 'counter', text: 7, options: { css: :red, position: :tl } }])
#=> "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
#   "<i class='fas fa-stack-1x blue fa-envelope fa-1x' style='' data-fa-transform='grow-0' title=''></i>" \
#   "<span class='fa-stack-1x red fa-layers-counter fa-layers-top-left' style='' data-fa-transform='grow-0'>7</span>" \
#   "</span>"

# The same stack, but using the FA::Build DSL (with various syntaxes).
FA::Build.p do
  icon('envelope', css: 'blue')
  span('counter', 7, css: 'red', position: :tl)
end

FA::Build.p do |b|
  b.icon('envelope', css: 'blue')
  b.span('counter', 7, css: 'red', position: :tl)
end

FA::Build.new do |b|
  b.icon('envelope', css: 'blue')
  b.span('counter', 7, css: 'red', position: :tl)
end.safe
```
