class PlainRenderer 
  
  def initialize(env)
    @env = env
  end

  def render(binding)
    [template, 'text/plain']
  end

  private

  def template
    @env['simpler.template']
  end
end