require 'redcarpet'

module Formatting

  def self.format(parser, text)
    Redcarpet::Markdown.new(parser, :fenced_code_blocks => true).render(text)
  end

  def self.body
    Redcarpet::Render::HTML
  end

  def self.toc
    Redcarpet::Render::Base
  end

  def self.introduction
    Redcarpet::Render::HTML
  end

end
