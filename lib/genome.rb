class Genome
  ADD_NODE_MUTATE_CHANCE = 0.5
  ADD_LINK_MUTATE_CHANCE = 0.5

  attr_reader :genes, :input_ids, :output_ids
  def initialize
    @genes = []
    @input_ids = []
    @output_ids = []
    @hidden_ids = []
    @latest_node_id = nil
  end

  def next_hidden_node_id
    @latest_node_id += 1
    return @latest_node_id
  end

  def find in_id, out_id
    @genes.detect {|gene| gene.in == in_id && gene.out == out_id}
  end

  def connect_all! inputs, outputs
    @input_ids = inputs
    @output_ids = outputs
    @latest_node_id = inputs.last

    inputs.each do |input_id|
      outputs.each do |output_id|
        gene = Gene.new
        gene.in = input_id
        gene.out = output_id
        gene.weight = 1
        @genes << gene
      end
    end
  end

  def node_mutate
    random_connection = @genes.sample
    if !random_connection.enabled
      return
    end

    random_connection.disable!

    new_node_id = next_hidden_node_id
    @hidden_ids << new_node_id
    gene1 = Gene.new
    gene1.in = random_connection.in
    gene1.out = new_node_id
    gene1.weight = 1

    gene2 = Gene.new
    gene2.in = new_node_id
    gene2.out = random_connection.out
    gene2.weight = random_connection.weight

    @genes << gene1
    @genes << gene2
  end

  def link_mutate
    start_node = (@input_ids + @hidden_ids).sample
    end_node = (@output_ids + @hidden_ids).sample
    if !find(start_node, end_node) && !find(end_node, start_node) && start_node != end_node
      gene = Gene.new
      gene.in = start_node
      gene.out = end_node
      gene.weight = (rand * 4)-2
      @genes << gene
    end
  end

  def mutate!
    if rand < ADD_NODE_MUTATE_CHANCE
      node_mutate
    end

    if rand < ADD_LINK_MUTATE_CHANCE
      link_mutate
    end

    #Add more mutations
  end
end
