class Payment < ActiveRecord::Base
  attr_accessible :value, :transaction_hash
  belongs_to :invoice
end
