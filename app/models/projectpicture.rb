class Projectpicture < ActiveRecord::Base
  belongs_to :project

  #validates :filename, format: {with: /A\.(png|jpg|jpeg|gif)\z/i, message: "placeholder väärä formaatti" }
  validates_format_of :content_type, :with => /\Aimage/, :message  => 'voit ladata vain kuvia'
  validate :picture_size_validation

  def uploaded_file=(incoming_file)
    self.filename = incoming_file.original_filename
    self.content_type = incoming_file.content_type
    self.data = incoming_file.read
  end

  def filename=(new_filename)
    write_attribute('filename', sanitize_filename(new_filename))
  end

  private
  def sanitize_filename(filename)
    #get only the filename, not the whole path (from IE)
    just_filename = File.basename(filename)
    #replace all non-alphanumeric, underscore or periods with underscores
    just_filename.gsub(/[^\w\.\-]/, '_')
  end

  def picture_size_validation
    self.errors[:project] << 'Kuvan pitää olla kooltaan alle 3MB' if data.size > 3.megabytes
  end
end