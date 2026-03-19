require_relative '../utils/database'

class Banner
  COLLECTION = :banners

  attr_accessor :id, :image_url, :title, :subtitle, :link, :active, :created_at

  def self.all(filter = {})
    Database.collection(COLLECTION).find(filter).sort(created_at: -1).map { |b| from_hash(b) }
  end

  def self.active
    all({ active: true })
  end

  def self.find(id)
    return nil unless id && !id.empty?
    hash = Database.collection(COLLECTION).find({ _id: BSON::ObjectId.from_string(id) }).first
    from_hash(hash) if hash
  end

  def self.create(attrs)
    attrs[:active] = attrs[:active] == 'true' || attrs[:active] == true
    attrs[:created_at] = Time.now
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.update(id, attrs)
    attrs[:active] = attrs[:active] == 'true' || attrs[:active] == true if attrs.key?(:active)
    Database.collection(COLLECTION).update_one({ _id: BSON::ObjectId.from_string(id) }, { '$set' => attrs })
  end

  def self.delete(id)
    Database.collection(COLLECTION).delete_one({ _id: BSON::ObjectId.from_string(id) })
  end

  def self.from_hash(hash)
    banner = new
    banner.id = hash['_id']
    banner.image_url = hash['image_url']
    banner.title = hash['title']
    banner.subtitle = hash['subtitle']
    banner.link = hash['link']
    banner.active = hash['active']
    banner.created_at = hash['created_at']
    banner
  end
end
