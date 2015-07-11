class PigsController < InheritedResources::Base

  private

    def pig_params
      params.require(:pig).permit(:name, :amount)
    end
end

