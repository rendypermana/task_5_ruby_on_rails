class Article < ActiveRecord::Base
	validates :title, presence: true,

                            length: { minimum: 5 }

    validates :content, presence: true,

                            length: { minimum: 10 }

    validates :status, presence: true

    scope :status_active, -> {where(status: 'active')}

    #name relation must plural
	has_many :comments
	has_many :user, through: :comments

	def self.import(file)
	  spreadsheet = Roo::Spreadsheet.open(file.path)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
	  article = find_by(id: row["id"]) || new
	  article.attributes = row.to_hash
	  article.save!
  	  end
	end


	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
	  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
	  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end




	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |article|
	      csv << article.attributes.values_at(*column_names)
	    end
	  end
	end

	def self.to_xls(options = {})
	  CSV.generate(options) do |xls|
	    xls << column_names
	    all.each do |article|
	      csv << article.attributes.values_at(*column_names)
	    end
	  end
	end

end
