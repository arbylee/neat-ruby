class Network
  attr_reader :nodes
  def initialize genome
    @nodes = []
    @genome = genome
  end

  def add_node node
    @nodes << node
  end

  def node_ids
    return @nodes.map { |node| node.id }
  end

  def find_node id
    @nodes.detect { |node| node.id == id }
  end

  def find_connection in_id, out_id
    @genome.find(in_id, out_id) || @genome.find(out_id, in_id)
  end

  def input_nodes
    return @nodes.select { |node| node.is_input_node? }
  end

  def output_nodes
    return @nodes.select { |node| node.is_output_node? }
  end

  def hidden_nodes
    return @nodes.select { |node| node.is_hidden_node? }
  end

  def sorted_nodes
    sorted = input_nodes
    sorted_ids = input_nodes.collect { |node| node.id }
    while sorted.length < @nodes.length
      found_nodes = false
      @nodes.each do |node|
        if (node.input_node_ids.all? { |id| sorted_ids.include? id }) && !sorted.include?(node)
          found_nodes = true
          sorted << node
          sorted_ids << node.id
        end
      end
      if !found_nodes
        break
      end
    end

    return sorted
  end
end
