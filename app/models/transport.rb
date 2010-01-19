class Transport < ActiveRecord::Base
  Types = [
    'email', 'http', 'postal', 'telephone'
  ]
  belongs_to :player  

  validates_associated :player
  validates_presence_of :player_id
  
  validates_uniqueness_of :address, :scope => [:player_id, :transport]

end
