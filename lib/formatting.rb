require 'redcarpet'

module Formatting

  OPTIONS = { :no_intra_emphasis => true, :fenced_code_blocks => true }

  def self.format(parser, text)
    Redcarpet::Markdown.new(parser, OPTIONS).render(text)
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
