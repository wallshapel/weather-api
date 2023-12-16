class Record < ApplicationRecord
    
    belongs_to :city
    validates :humidity, presence: true
    
end