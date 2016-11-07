class Node
  attr_reader :input_node_ids, :id, :type, :value
  attr_writer :value
  def initialize id, type
    @id = id
    @type = type
    @value = 0
    @input_node_ids = []
  end

  def add_input_node input_node_id
    @input_node_ids << input_node_id
  end

  def is_input_node?
    @type == "Input"
  end

  def is_output_node?
    @type == "Output"
  end

  def is_hidden_node?
    @type == "Hidden"
  end
end
