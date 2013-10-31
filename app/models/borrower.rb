class Borrower
  include Mongoid::Document
  belongs_to :note
  belongs_to :user
end
