Player.create(:signifier => 'host')
player = Player.create(:signifier => 'devplayer')
puts "DevPlayer is #{player.inspect}"
player.transports.create(:transport => 'email', :address => DevPlayerEmail )