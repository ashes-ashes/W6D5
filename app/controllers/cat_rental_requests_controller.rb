class CatRentalRequestsController < ApplicationController

    def new
        @cats = Cat.all
        render :new
    end

    def create
        @request = CatRentalRequest.new(request_params)
        if @request.save
            redirect_to cat_url(@request.cat)
        else
            redirect_to new_cat_rental_request_url
        end
    end

    private

  def request_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end
end
