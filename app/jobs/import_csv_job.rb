class ImportCsvJob < ApplicationJob
  require 'csv'
  queue_as :default

  def perform(filename)
    # Do something later
    puts filename
    byebug
    csv_file = File.read(Rails.root.join('public', 'uploads', filename))
    logger.info("importing #{filename} file")
    error_import = []
    CSV.parse(csv_file, :headers => true).each do |row|
      formatted_hash = {}
      # lowercase the keys
      # split name to first_name and last_name
      # formatted_hash = row.to_h.map{|k, v| formatted_hash.merge!({k.downcase => v})}

      formatted_hash = Hash[row.to_h.map { |k, v| [k.downcase, v] }]
      name = formatted_hash["name"]
      if name
        formatted_hash.delete("name")
        name_split = name.split(" ")
        formatted_hash.merge!(Hash["first_name", name_split[0], "last_name", name_split.size > 1 ? name_split.last : ''])
      end

      # create person object
      p = Person.new(formatted_hash.reject{|k, v| %w(affiliations location).include?(k.to_s)})
      # process each for location and affiliation keys
      unless formatted_hash['affiliations'].nil?
        formatted_hash['affiliations'].split(",").each do |aff|
          p.affiliations << Affiliation.create({name: aff})
        end
      end

      unless formatted_hash['location'].nil?
        formatted_hash['location'].split(",").each do |loc|
          p.locations<< Location.create({name: loc})
        end
      end

      unless p.valid?
        puts p.errors.messages
      end

      p.valid? ? p.save : error_import << formatted_hash
    end
    logger.info("invalid or unimported data ---- ")
    logger.info(error_import)
    UserMailer.with(filename: filename).imported_successfully.deliver_later
  end

  def reschedule_at(current_time, attempts)
    current_time + 5.seconds
  end

end
