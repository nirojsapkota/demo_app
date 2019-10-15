class PeopleController < ApplicationController
  before_action :set_person, only: [:show]

  def index

    if params[:query] && !params[:query].blank?
      @people = Person.query(params[:query]).paginate(page: params[:page], per_page: 10)
    else
      @people = Person.paginate(page: params[:page], per_page: 10)
    end
  end

  def show
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end
end
