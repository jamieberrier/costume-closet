module DancersHelper
  def find_dancer
    @dancer = Dancer.find(params[:id])
  end
end
