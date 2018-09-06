class PlainRenderer 
  
  def initialize(template)
    @template = template
  end

  def response
    [@template[:plain], 'text/plain']
  end
end