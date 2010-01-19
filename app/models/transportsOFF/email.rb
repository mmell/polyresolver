class Email < Transport
  belongs_to :player  

  validates_associated :player
  validates_presence_of :player

  validates_format_of :address, :with => /^[^[:space:]@]+@(([[:alnum:]\-_\+\>])+\.)+[[:alpha:]]{2,6}$/
end
