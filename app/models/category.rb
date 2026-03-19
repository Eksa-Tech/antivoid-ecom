require_relative '../utils/database'

class Category
  COLLECTION = :categories

  attr_accessor :id, :name, :slug

  @cache = nil
  @cache_time = nil

  def self.all
    if @cache && @cache_time && Time.now - @cache_time < 300
      return @cache
    end
    @cache = Database.collection(COLLECTION).find.map { |c| from_hash(c) }
    @cache_time = Time.now
    @cache
  end

  def self.clear_cache
    @cache = nil
  end

  def self.count(filter = {})
    Database.collection(COLLECTION).count_documents(filter)
  end

  def self.create(attrs)
    attrs[:slug] = attrs[:name].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    Database.collection(COLLECTION).insert_one(attrs)
    clear_cache
  end

  def self.delete(id)
    Database.collection(COLLECTION).delete_one(_id: BSON::ObjectId.from_string(id))
    clear_cache
  end

  def self.from_hash(hash)
    cat = new
    cat.id = hash['_id']
    cat.name = hash['name']
    cat.slug = hash['slug']
    cat
  end
end
