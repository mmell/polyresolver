Player.create(:signifier => 'host')
player = Player.create(:signifier => 'devplayer')
puts "DevPlayer is #{player.inspect}"
Player.find_by_signifier('devplayer').transports.create(:transport => 'email', :address => DevPlayerEmail )