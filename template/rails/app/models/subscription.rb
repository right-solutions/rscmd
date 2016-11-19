class Subscription < ActiveRecord::Base

  # Validations
  extend PoodleValidators
  validates :email, :presence=> true

  # ------------------
  # Class Methods
  # ------------------
  
  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(email) LIKE LOWER('%#{query}%')")
                        }

  # Scopes
  scope :this_month, lambda { where("created_at >= ? AND created_at <= ?", 
  																		Time.zone.now.beginning_of_month, Time.zone.now.end_of_month) }
  
end
