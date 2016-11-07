class Gene
  attr_reader :enabled
  attr_writer :innovation
  attr_accessor :weight, :in, :out

  def initialize
    @in = nil
    @out = nil
    @weight = nil
    @innovation = 0
    @enabled = true
  end

  def disable!
    @enabled = false
  end
end
