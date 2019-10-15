class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  def index

    if params[:query].present?
      @people = Person.query(params[:query]).includes(:affiliations, :locations)
    else
      @people = Person.includes(:affiliations, :locations)
    end
    if params[:order].present?
      order_string = "#{params[:order]} #{params[:sort_mode]}"
      @people = @people.order(order_string)
    end
    @people = @people.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end
end
