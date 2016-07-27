# require 'SecureRandom'


class ShortenedURL < ActiveRecord::Base
  validates :short_url, uniqueness: true
  validate :url_too_long
  validate :no_spamming

  def self.random_code
    code = nil
    until code
      code = SecureRandom.urlsafe_base64[0...16]
      code = nil if ShortenedURL.exists?(short_url: code)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    create!(user_id: user.id, long_url: long_url, short_url: random_code)
  end

  def self.most_popular_by_topic(topic_id, n)
    ShortenedURL
      .joins("JOIN taggings ON taggings.url_id = shortened_urls.id")
      .joins("JOIN visits ON visits.url_id = shortened_urls.id")
      .group("shortened_urls.id")
      .where("taggings.topic_id = ?", topic_id)
      .order("COUNT(visits.url_id) DESC")
      .limit(n)
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  has_many :taggings,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tagging

  has_many :topics,
    through: :taggings,
    source: :tag_topic

  def no_spamming
    urls = submitter.submitted_urls.where("created_at > ?", 1.minutes.ago)
    if urls.count >= 5
      self.errors[:user] << "submitted too many URLs in last minute"
    end
  end

  def url_too_long
    unless long_url.length <= 255
      self.errors[:URL] << "is too long"
    end
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    ShortenedURL
      .select(:user_id)
      .distinct
      .where("created_at > :recent_time", recent_time: 10.minutes.ago)
      .count
  end

end
