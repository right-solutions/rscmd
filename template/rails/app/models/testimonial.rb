class Testimonial < ActiveRecord::Base

  # Constants
  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  DELETED = "deleted"
  STATUS_LIST = [PUBLISHED, UNPUBLISHED, DELETED]

  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at]

  # Validations
  extend PoodleValidators
  validate_string :name, mandatory: true
  
  validates :designation, :presence=> false
  validates :organisation, :presence=> true
  validates :statement, :presence=> true
  
  validates :status, :presence=> true, :inclusion => {:in => STATUS_LIST, :presence_of => :status, :message => "%{value} is not a valid status" }

  # Associations
  has_one :picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::Testimonial::Picture"

  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(designation) LIKE LOWER('%#{query}%') OR\
                                        LOWER(organisation) LIKE LOWER('%#{query}%') OR\
                                        LOWER(statement) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where ("LOWER(status)='#{status}'") }
  scope :published, -> { where(status: PUBLISHED) }
  scope :unpublished, -> { where(status: UNPUBLISHED) }
  scope :deleted, -> { where(status: DELETED) }

  scope :this_month, lambda { where("created_at >= ? AND created_at <= ?", 
                                      Time.zone.now.beginning_of_month, Time.zone.now.end_of_month) }
  
  # ------------------
  # Instance variables
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    #options[:include] = []
    options[:except] = EXCLUDED_JSON_ATTRIBUTES

    super(options)
  end

  # * Return true if the enquiry is published, else false.
  # == Examples
  #   >>> enquiry.published?
  #   => true
  def published?
    (status == PUBLISHED)
  end

  # change the status to :published
  # Return the status
  # == Examples
  #   >>> enquiry.published!
  #   => "published"
  def published!
    self.update_attribute(:status, PUBLISHED)
  end

  # * Return true if the enquiry is unpublished, else false.
  # == Examples
  #   >>> enquiry.unpublished?
  #   => true
  def unpublished?
    (status == UNPUBLISHED)
  end

  # change the status to :unpublished
  # Return the status
  # == Examples
  #   >>> enquiry.unpublished!
  #   => "unpublished"
  def unpublished!
    self.update_attribute(:status, UNPUBLISHED)
  end

  # * Return true if the enquiry is deleted, else false.
  # == Examples
  #   >>> enquiry.deleted?
  #   => true
  def deleted?
    (status == DELETED)
  end

  # change the status to :deleted
  # Return the status
  # == Examples
  #   >>> enquiry.deleted!
  #   => "deleted"
  def deleted!
    self.update_attribute(:status, DELETED)
  end

  def default_image_url(size="medium")
    "/assets/defaults/testimonial-#{size}.png"
  end
  
end
