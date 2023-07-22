# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FA do
  describe 'link' do
    it 'generates the correct link tag' do
      tag = FA::Link.new(version: 'v0.1.2', integrity: 'sha384-abc', pro: true)
      expect(tag.safe).to eql(
        '<link rel="stylesheet" ' \
        'href="https://pro.fontawesome.com/releases/v0.1.2/css/all.css" ' \
        'integrity="sha384-abc" crossorigin="anonymous">'
      )
    end

    it 'generates the correct kit link tag' do
      tag = FA::Link.kit('abcdefg')
      expect(tag).to eql(
        "<script src=\"https://kit.fontawesome.com/abcdefg.js\" async></script>"
      )
    end

    it 'raises an ArgumentError if not initialized correctly' do
      expect { FA::Link.new(version: 'v0.0.0', pro: true) }.to raise_error(
        ArgumentError, 'Must specify version and integrity or kit.'
      )
    end
  end

  describe 'icon' do
    it 'generates the correct icon from a string name' do
      expect(FA::Icon.p('help')).to eql(
        "<i class='fas fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct icon from a symbol name' do
      expect(FA::Icon.p(:help)).to eql(
        "<i class='fas fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct icon from a configuration hash' do
      fa = { name: 'help', options: { style: :light, size: 2 } }
      expect(FA::Icon.p(fa)).to eql(
        "<i class='fal fa-help fa-2x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'handles a string fa option' do
      expect(FA::Icon.p(:help, fa: 'fw 2x')).to eql(
        "<i class='fas fa-fw fa-2x fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'handles an array fa option' do
      expect(FA::Icon.p(:help, fa: %i[fw 2x])).to eql(
        "<i class='fas fa-fw fa-2x fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'handles a string css option' do
      expect(FA::Icon.p(:help, css: 'green big')).to eql(
        "<i class='fas green big fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'handles an array css option' do
      expect(FA::Icon.p(:help, css: %i[green big])).to eql(
        "<i class='fas green big fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'handles a nil css option' do
      expect(FA::Icon.p(:help, css: nil)).to eql(
        "<i class='fas fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'raises ArgumentError for other input types' do
      [nil, [], 0].each do |fa|
        expect { FA::Icon.p(fa) }.to raise_error(
          ArgumentError, 'Unexpected argument type.'
        )
      end
    end

    it 'generates the correct icon with a manual style class' do
      expect(FA::Icon.p(:help, style: :solid, css: 'fad')).to eql(
        "<i class='fad fa-help fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct brand icon' do
      expect(FA::Icon.p(:github, style: :brands)).to eql(
        "<i class='fab fa-github fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct sharp icon' do
      expect(FA::Icon.p(:house, mode: :sharp)).to eql(
        "<i class='fass fa-house fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct sharp regular icon' do
      expect(FA::Icon.p(:house, style: :regular, mode: :sharp)).to eql(
        "<i class='fasr fa-house fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct sharp light icon' do
      expect(FA::Icon.p(:house, style: :light, mode: :sharp)).to eql(
        "<i class='fasl fa-house fa-1x' id='' style='' data-fa-transform='' title=''></i>"
      )
    end

    it 'generates the correct icon with styles' do
      expect(
        FA::Icon.p(
          'fire-alt', style: :duotone, fa_styles: {
            primary_opacity: '0.6', secondary_opacity: '0.4', primary_color: :green, secondary_color: '#DD2200'
          }
        )
      ).to eql(
        "<i class='fad fa-fire-alt fa-1x' id='' style='--fa-primary-opacity: 0.6; --fa-secondary-opacity: 0.4; " \
        "--fa-primary-color: green; --fa-secondary-color: #DD2200;' data-fa-transform='' title=''></i>"
      )
    end
  end

  describe 'layer' do
    it 'generates the correct layer from string or symbol names' do
      icons = [
        { name: :square },
        { name: :circle, options: { grow: 1 } },
        { name: 'exclamation', options: { style: :regular } }
      ]

      expect(FA::Layer.p(icons, grow: 2)).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
        "<i class='fas fa-stack-1x fa-square fa-1x' id='' style='' data-fa-transform='grow-2' title=''></i>" \
        "<i class='fas fa-stack-1x fa-circle fa-1x' id='' style='' data-fa-transform='grow-3' title=''></i>" \
        "<i class='far fa-stack-1x fa-exclamation fa-1x' id='' style='' data-fa-transform='grow-2' title=''></i>" \
        '</span>'
      )
    end

    it 'generates the correct layer with a span' do
      icons = [
        { name: :square },
        { name: :counter, text: 17, options: { position: :tl } }
      ]

      expect(FA::Layer.p(icons)).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
        "<i class='fas fa-stack-1x fa-square fa-1x' id='' style='' data-fa-transform='grow-0' title=''></i>" \
        "<span class='fa-stack-1x fa-layers-counter fa-layers-top-left' id='' style='' data-fa-transform='grow-0'>17</span>" \
        '</span>'
      )
    end

    it 'applies layer titles to all icons' do
      icons = [
        { name: :square, title: 'wrong 1' },
        { name: :exclamation, title: 'wrong 2' }
      ]

      expect(FA::Layer.p(icons, title: 'right')).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title='right'>" \
        "<i class='fas fa-stack-1x fa-square fa-1x' id='' style='' data-fa-transform='grow-0' title='right'></i>" \
        "<i class='fas fa-stack-1x fa-exclamation fa-1x' id='' style='' data-fa-transform='grow-0' title='right'></i>" \
        '</span>'
      )
    end
  end

  describe 'build' do
    it 'generates the correct layer' do
      layer = FA::Build.p do |b|
        b.icon('circle')
        b.span('counter', 7)
      end

      expect(layer).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
        "<i class='fas fa-stack-1x fa-circle fa-1x' id='' style='' data-fa-transform='grow-0' title=''></i>" \
        "<span class='fa-stack-1x fa-layers-counter ' id='' style='' data-fa-transform='grow-0'>7</span>" \
        '</span>'
      )
    end
  end

  describe 'span' do
    it 'generates the correct span from a string or symbol type' do
      expect(FA::Span.p(:text, 'Hello')).to eql(
        "<span class='fa-layers-text ' id='' style='' data-fa-transform=''>Hello</span>"
      )
    end

    it 'generates the correct span from a configuration hash' do
      span = { type: :text, text: 'World', options: { position: :bl } }
      expect(FA::Span.p(span)).to eql(
        "<span class='fa-layers-text fa-layers-bottom-left' " \
        "id='' style='' data-fa-transform=''>World</span>"
      )
    end

    it 'raises ArgumentError for other input types' do
      [nil, [], 0].each do |fa|
        expect { FA::Span.p(fa) }.to raise_error(
          ArgumentError, 'Unexpected argument type.'
        )
      end
    end
  end
end
