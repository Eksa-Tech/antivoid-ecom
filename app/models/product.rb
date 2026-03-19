require_relative '../utils/database'

class Product
  COLLECTION = :products

  attr_accessor :id, :name, :description, :price, :stock, :category_id, :image_url

  def self.all(filter = {}, limit: nil, skip: nil)
    query = Database.collection(COLLECTION).find(filter)
    query = query.limit(limit) if limit
    query = query.skip(skip) if skip
    query.map { |p| from_hash(p) }
  end

  def self.count(filter = {})
    Database.collection(COLLECTION).count_documents(filter)
  end

  def self.find(id)
    return nil if id.nil? || id.to_s.strip.empty?
    data = Database.collection(COLLECTION).find(_id: BSON::ObjectId.from_string(id)).first
    data ? from_hash(data) : nil
  rescue BSON::Error::InvalidObjectId, BSON::Error::InvalidString
    nil
  end

  def self.create(attrs)
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.update(id, attrs)
    Database.collection(COLLECTION).update_one({ _id: BSON::ObjectId.from_string(id) }, { '$set' => attrs })
  end

  def self.delete(id)
    Database.collection(COLLECTION).delete_one(_id: BSON::ObjectId.from_string(id))
  end

  def self.from_hash(hash)
    prod = new
    prod.id = hash['_id']
    prod.name = hash['name']
    prod.description = hash['description']
    prod.price = hash['price']
    prod.stock = hash['stock']
    prod.category_id = hash['category_id']
    prod.image_url = hash['image_url']
    prod
  end
end
