# FA Rails

A quick helper for using FontAwesome icons in Rails.

## Installation

**This gem is just the code for using FontAwesome in your Rails applications.**

You must still have your own FontAwesome Pro license, or install the
[Free](https://use.fontawesome.com/releases/v5.2.0/fontawesome-free-5.2.0-web.zip)
package.

### Local Files

Copy the complete `js` and `css` directories from the
[web download](https://fontawesome.com/releases/5.2.0/web/download) into the
corresponding locations in your app, and ensure you correctly include all files.

Add the following to `config/application.rb`:

```ruby
require 'fa'
```

### FontAwesome CDN

Go to the FontAwesome
[How to Use](https://fontawesome.com/how-to-use/on-the-web/setup/getting-started?using=web-fonts-with-css)
page and copy the appropriate CDN link tag:

#### Free

```html
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-some-key-here" crossorigin="anonymous">
```

#### Pro

```html
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-some-key-here" crossorigin="anonymous">
```

**Be sure to also need to register each domain that will use this CDN link.**

## Usage

The `FA` module contains three main subclasses: `Icon`, `Span`, and `Layer`.
Argument formatting is consistent throughout.

`Icon` and `Span` are the units of this module. Both can be used individually.  
The first argument of each class's `new` method can be either a String/Symbol of
the name of the FontAwesome icon, or a Hash containing the complete
configuration for the object.

`Layer` is used to combine multiple units into a single end object. It takes
advantage of the Hash input style on `Icon` and `Span` to allow it to accept a
single configuration Hash for the entire stack.

All three classes respond to two output methods: `raw` and `safe`.

- `raw` outputs the formatted string directly
- `safe` attempts to call `.html_safe` on the formatted string, if available

### Icon

A single FontAwesome icon.

#### Icon Arguments

```ruby
fa #=> String / Symbol – OR Hash
options #=> Hash
  style: Symbol # One of [:solid, :regular, :light, :brands], default :solid
  size: Integer # Stepped scaling factor

  css: String # Arbitrary CSS classes, space-delimited
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
css # String – arbitrary CSS classes, space-delimited, applied to the layer stack
```

### Examples

```ruby
# Fixed-width lock icon
FA::Icon.new('lock', fa: 'fw').safe
#=> "<i class='fas fa-fw fa-lock' data-fa-transform='' title=''></i>"

# Counter span, with value 5
FA::Span.new('counter', 5).safe
#=> "<span class='fa-layers-counter ' data-fa-transform=''>5</span>

# Gray envelope icon with red exclamation mark overlayed, with tooltip 'Invalid email address'
FA::Layer.new([{ name: 'envelope', options: { css: :gray } }, { name: 'exclamation', options: { css: :red } }], title: 'Invalid email address').safe
#=> "<span class='icon fa-layers fa-fw ' title='Invalid email address'>" \
#   "<i class='fas gray fa-envelope' data-fa-transform='grow-0' title=''></i>" \
#   "<i class='fas red fa-exclamation' data-fa-transform='grow-0' title=''></i>" \
#   "</span>"

# Blue envelope with red counter on the top left corner, with value 7
FA::Layer.new([{ name: 'envelope', options: { css: :blue } }, { name: 'counter', text: 7, options: { css: :red, position: :tl } }]).safe
#=> "<span class='icon fa-layers fa-fw ' title=''>" \
#   "<i class='fas gray fa-envelope' data-fa-transform='grow-0' title=''></i>" \
#   "<span class='red fa-layers-counter ' data-fa-transform='grow-0'>7" \
#   "</span>" \
#   "</span>"
```
