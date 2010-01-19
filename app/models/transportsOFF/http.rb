class Http < Transport
  belongs_to :player  

  validates_associated :player
  validates_presence_of :player
end
