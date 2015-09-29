class Input < Struct.new(:input_stream)
  def get
    input_stream.gets.strip
  end
end
