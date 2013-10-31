class Lender
  include Mongoid::Document
  belongs_to :note
  belongs_to :user
end
