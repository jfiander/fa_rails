# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FA do
  it 'should generate the correct link tag' do
    tag = FA::Link.new(version: 'v0.1.2', integrity: 'sha384-abc', pro: true)
    expect(tag.safe).to eql(
      '<link rel="stylesheet" ' \
      'href="https://pro.fontawesome.com/releases/v0.1.2/css/all.css" ' \
      'integrity="sha384-abc" crossorigin="anonymous">'
    )
  end

  describe 'icon' do
    it 'should generate the correct icon from a string or symbol name' do
      expect(FA::Icon.new('help').safe).to eql(
        "<i class='fas fa-help fa-1x' data-fa-transform='' title=''></i>"
      )

      expect(FA::Icon.new(:help).safe).to eql(
        "<i class='fas fa-help fa-1x' data-fa-transform='' title=''></i>"
      )
    end

    it 'should generate the correct icon from a configuration hash' do
      fa = { name: 'help', options: { style: :light, size: 2 } }
      expect(FA::Icon.new(fa).safe).to eql(
        "<i class='fal fa-help fa-2x' data-fa-transform='' title=''></i>"
      )
    end

    it 'should raise ArgumentError for other input types' do
      [nil, [], 0].each do |fa|
        expect { FA::Icon.new(fa).safe }.to raise_error(
          ArgumentError, 'Unexpected argument type.'
        )
      end
    end

    it 'should generate the correct brand icon' do
      expect(FA::Icon.new(:github, style: :brands).safe).to eql(
        "<i class='fab fa-github fa-1x' data-fa-transform='' title=''></i>"
      )
    end
  end

  describe 'layer' do
    it 'should generate the correct layer from string or symbol names' do
      icons = [
        { name: :square },
        { name: :circle, options: { grow: 1 } },
        { name: 'exclamation', options: { style: :regular } }
      ]

      expect(FA::Layer.new(icons, grow: 2).safe).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
        "<i class='fas fa-stack-1x fa-square fa-1x' data-fa-transform='grow-2' title=''></i>" \
        "<i class='fas fa-stack-1x fa-circle fa-1x' data-fa-transform='grow-3' title=''></i>" \
        "<i class='far fa-stack-1x fa-exclamation fa-1x' data-fa-transform='grow-2' title=''>" \
        '</i></span>'
      )
    end

    it 'should generate the correct layer with a span' do
      icons = [
        { name: :square },
        { name: :counter, text: 17, options: { position: :tl } }
      ]

      expect(FA::Layer.new(icons).safe).to eql(
        "<span class='icon fa-layers fa-stack fa-fw ' title=''>" \
        "<i class='fas fa-stack-1x fa-square fa-1x' data-fa-transform='grow-0' title=''></i>" \
        "<span class='fa-stack-1x fa-layers-counter fa-layers-top-left' " \
        "data-fa-transform='grow-0'>17</span></span>"
      )
    end
  end

  describe 'span' do
    it 'should generate the correct span from a string or symbol type' do
      expect(FA::Span.new(:text, 'Hello').safe).to eql(
        "<span class='fa-layers-text ' data-fa-transform=''>Hello</span>"
      )
    end

    it 'should generate the correct span from a configuration hash' do
      span = { type: :text, text: 'World', options: { position: :bl } }
      expect(FA::Span.new(span).safe).to eql(
        "<span class='fa-layers-text fa-layers-bottom-left' " \
        "data-fa-transform=''>World</span>"
      )
    end

    it 'should raise ArgumentError for other input types' do
      [nil, [], 0].each do |fa|
        expect { FA::Span.new(fa).safe }.to raise_error(
          ArgumentError, 'Unexpected argument type.'
        )
      end
    end
  end
end
