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

#######################

# csv_file = File.read(Rails.root.join('public', 'uploads', filename))
#     logger.info("importing #{filename} file")
#     error_import = []
#     CSV.parse(csv_file, :headers => true).each do |row|
#       formatted_hash = {}
#       # lowercase the keys
#       # split name to first_name and last_name
#       # formatted_hash = row.to_h.map{|k, v| formatted_hash.merge!({k.downcase => v})}

#       formatted_hash = Hash[row.to_h.map { |k, v| [k.downcase, v] }]
#       name = formatted_hash["name"]
#       if name
#         formatted_hash.delete("name")
#         name_split = name.split(" ")
#         formatted_hash.merge!(Hash["first_name", name_split[0], "last_name", name_split.size > 1 ? name_split.last : ''])
#       end

#       # create person object
#       p = Person.new(formatted_hash.reject{|k, v| %w(affiliations location).include?(k.to_s)})
#       # process each for location and affiliation keys
#       unless formatted_hash['affiliations'].nil?
#         formatted_hash['affiliations'].split(",").each do |aff|
#           p.affiliations << Affiliation.create({name: aff})
#         end
#       end

#       unless formatted_hash['location'].nil?
#         formatted_hash['location'].split(",").each do |loc|
#           p.locations<< Location.create({name: loc})
#         end
#       end
#       byebug

#       unless p.valid?
#         puts p.errors.messages
#       end

#       p.valid? ? p.save : error_import << formatted_hash
#     end

#######################


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
