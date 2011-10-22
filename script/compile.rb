file = ARGV[0]

started = Time.now

fail "Cannot find #{file}" unless File.exist?(file)

id = File.basename(file, ".md")
puts "Parsing #{id}"

text = File.open(file, 'r:utf-8').read

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'contents_storage'
require 'body'
require 'table_of_contents'
require 'introduction'
require 'code'

contents = { "html" => Body.read(text), "toc" => TableOfContents.read(text), "introduction" => Introduction.read(text) }

ContentsStorage.new(id).write(contents)

ended = Time.now

puts "Compiled in %.02f seconds" % (ended - started)
