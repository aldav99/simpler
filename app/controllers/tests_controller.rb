class TestsController < Simpler::Controller

  def index
    # render 'tests/list'
    # render "Plain text response\n", format: :plain, status: 201 
    @time = Time.now
  end

  def create

  end

  def show
    @route_parameter = route_params
    @request_params = request_params
  end

end
