require_relative '../utils/database'

class Category
  COLLECTION = :categories

  attr_accessor :id, :name, :slug

  def self.all
    Database.collection(COLLECTION).find.map { |c| from_hash(c) }
  end

  def self.count(filter = {})
    Database.collection(COLLECTION).count_documents(filter)
  end

  def self.create(attrs)
    attrs[:slug] = attrs[:name].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.delete(id)
    Database.collection(COLLECTION).delete_one(_id: BSON::ObjectId.from_string(id))
  end

  def self.from_hash(hash)
    cat = new
    cat.id = hash['_id']
    cat.name = hash['name']
    cat.slug = hash['slug']
    cat
  end
end
