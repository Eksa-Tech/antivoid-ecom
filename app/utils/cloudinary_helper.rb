require 'cloudinary'

module CloudinaryHelper
  def self.configure
    Cloudinary.config_from_url(ENV['CLOUDINARY_URL']) if ENV['CLOUDINARY_URL']
  end

  def self.upload(file_path)
    configure
    result = Cloudinary::Uploader.upload(file_path)
    result['secure_url']
  rescue StandardError => e
    puts "Cloudinary upload error: #{e.message}"
    nil
  end

  def self.delete(url)
    return unless url && url.include?('cloudinary.com')
    configure
    public_id = extract_public_id(url)
    Cloudinary::Uploader.destroy(public_id) if public_id
  rescue StandardError => e
    puts "Cloudinary delete error: #{e.message}"
  end

  private

  def self.extract_public_id(url)
    part = url.split('upload/').last
    return nil unless part
    
    # Remove version if present (e.g. v12345678/)
    part = part.gsub(/^v\d+\//, '')
    
    # Remove extension
    part.split('.').first
  end
end
