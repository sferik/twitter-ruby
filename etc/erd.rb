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

nodes = {}
edges = {}

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

@indent = 0

def indent
  @indent += 1
  yield
  @indent -= 1
end

def puts(string)
  super(TAB * @indent + string)
end

puts 'digraph classes {'
# Add or remove DOT formatting options here
indent do
  puts 'graph [rotate=0, rankdir="LR"]'
  puts 'node [fillcolor="#c4ddec", style="filled", fontname="Helvetica Neue"]'
  puts 'edge [color="#444444"]'
  nodes.sort.each do |node, label|
    puts "#{node} [label=\"#{label}\"]"
  end
  edges.sort.each do |child, parent|
    puts "#{child} -> #{parent}"
  end
end
puts '}'
