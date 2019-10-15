class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]
  require 'csv'
  # GET /imports
  # GET /imports.json
  def index
    @imports = nil
  end

  # GET /imports/new
  def new
  end

  # POST /imports
  # POST /imports.json
  def create
    # Here get the file and send to the background job

    uploaded_file = params[:import_csv]
    error = nil
    if uploaded_file
      file_name_split = uploaded_file.original_filename.split('.')
      filename = "#{file_name_split[0].strip.parameterize}.#{file_name_split[1]}"
      begin
        File.open(Rails.root.join('public', 'uploads', filename), 'w') do |f|
          # store the file to re-import if incase the csv import fails
          # additonal logic not covered
          f.write(uploaded_file.read)
          f.close
        end

        ImportCsvJob.perform_later(filename)
      rescue StandardError => e
        error = e.message
      end
    else
      error = "No file to process"
    end

    respond_to do |format|
      format.html { redirect_to imports_url, notice: error ? error : 'File is being imported. An email will be sent upon successful completion.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_import
    @import = Import.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.fetch(:import, {})
  end
end
