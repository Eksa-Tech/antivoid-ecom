require_relative '../utils/database'

class Review
  COLLECTION = :reviews

  attr_accessor :id, :product_id, :user_id, :user_name, :rating, :comment, :created_at

  def self.all_for_product(product_id)
    Database.collection(COLLECTION).find(product_id: product_id.to_s).sort(created_at: -1).map { |r| from_hash(r) }
  end

  def self.create(attrs)
    attrs[:created_at] = Time.now
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.from_hash(hash)
    review = new
    review.id = hash['_id']
    review.product_id = hash['product_id']
    review.user_id = hash['user_id']
    review.user_name = hash['user_name']
    review.rating = hash['rating']
    review.comment = hash['comment']
    review.created_at = hash['created_at']
    review
  end
end
