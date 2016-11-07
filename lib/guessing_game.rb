require_relative './gene'
require_relative './node'
require_relative './genome'
require_relative './network'

training_set = []
primes = [2,3,5,7,11,13,17,19,23,29,31]

(1..33).each do |i|
  if primes.include? i
    expected = 1
  else
    expected = 0
  end
  training_set << {input: i, expected_output: expected}
end

def evaluate_network network, training
  fitness = 0
  training.each do |tdata|

    # FIXME handle multiple inputs in training data. Do a zip with inputs or something. Need to ensure order is preserved
    network.nodes.each do |node|
      if node.is_input_node?
        node.value = tdata[:input]
      end
    end

    # Must run this in layers
    #network.sorted_genes.each do |gene|
    #  if gene.enabled
    #    p gene
    #    sum = 0
    #    input_node = network.find_node gene.in
    #    output_node = network.find_node gene.out
    #    if input_node.value.nil?
    #      p network.sorted_genes
    #      p input_node
    #      p output_node
    #      p network
    #    end
    #    sum += input_node.value * gene.weight
    #    output_node.value = sigmoid(sum)
    #  end
    #end

    network.sorted_nodes.each do |node|
      sum = 0
      node.input_node_ids.each do |input_node_id|
        connection = network.find_connection(input_node_id, node.id)
        if connection.enabled
          input_node = network.find_node input_node_id
          sum += input_node.value * connection.weight
        end
      end
      node.value = sigmoid(sum)
    end

    network.output_nodes.each do |node|
      sum = 0
      node.input_node_ids.each do |input_node_id|
        connection = network.find_connection(input_node_id, node.id)
        if connection.enabled
          input_node = network.find_node input_node_id
          sum += input_node.value * connection.weight
        end
      end
      node.value = sigmoid(sum)
    end

    network.output_nodes.each do |output_node|
      if output_node.value == tdata[:expected_output]
        fitness += 1
      end
    end

  end
  return fitness
end

def sigmoid val
  return 2/(1+Math.exp(-4.9*val))-1
end

def generate_network genome
  network = Network.new genome
  genome.input_ids.each do |id|
    node = Node.new id, "Input"
    network.add_node node
  end

  genome.output_ids.each do |id|
    node = Node.new id, "Output"
    network.add_node node
  end

  genome.genes.each do |gene|
    if !network.node_ids.include?(gene.in)
      node = Node.new gene.in, "Hidden"
      network.add_node node
    end

    if !network.node_ids.include?(gene.out)
      node = Node.new gene.out, "Hidden"
      network.add_node node
    end

    node_with_input = network.find_node gene.out
    node_with_input.add_input_node gene.in
  end

  return network
end

genome = Genome.new
inputs = [1]
outputs = [10000]
genome.connect_all! inputs, outputs
100.times do
  genome.mutate!
  network = generate_network(genome)
  result = evaluate_network network, training_set
  puts result
  p "------"
end
