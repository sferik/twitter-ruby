#!/usr/bin/ruby

require 'twitter'

COLON = ':'.freeze
UNDERSCORE = '_'.freeze
TAB = "\t".freeze
NAMESPACE = 'Twitter::'.freeze

# Colons are invalid characters in DOT nodes.
# Replace them with underscores.
# http://www.graphviz.org/doc/info/lang.html
def nodize(klass)
  klass.name.tr(COLON, UNDERSCORE)
end

nodes, edges = {}, {}

twitter_objects = ObjectSpace.each_object(Class).select do |klass|
  klass.name.to_s.start_with?(NAMESPACE)
end

twitter_objects.each do |klass|
  loop do
    unless klass.nil? || klass.superclass.nil? || klass.name.empty?
      nodes[nodize(klass)] = klass.name
      edges[nodize(klass)] = nodize(klass.superclass)
    end
    klass = klass.superclass
    break if klass.nil?
  end
end

edges.delete(nil)

def puts(object, indent = 0, tab = TAB)
  super(tab * indent + object)
end

puts 'digraph classes {'
# Add or remove DOT formatting options here
puts "graph [rotate=0, rankdir=\"LR\"]", 1
puts "node [fillcolor=\"#c4ddec\", style=\"filled\", fontname=\"Helvetica Neue\"]", 1
puts "edge [color=\"#444444\"]", 1
nodes.sort.each do |node, label|
  puts "#{node} [label=\"#{label}\"]", 1
end
edges.sort.each do |child, parent|
  puts "#{child} -> #{parent}", 1
end
puts '}'
