Factory.sequence :signifier do |n|
  "signifier#{n.to_s.rjust(4,'0')}"
end

Factory.sequence :email do |n|
  "email#{n.to_s.rjust(4,'0')}@example.com"
end

Factory.define :player do |f|
#  f.signifier { Factory.next(:signifier) }
end

Factory.define :resolver do |f|
  f.end_point "#{DevPlayerEndPoint}/resolvers"
  f.public_key { Player.generate_keypair[:public_key] }
end

Factory.define :peer do |f|
  f.player { Factory.create(:player) }
  f.resolver { Factory.create(:resolver) }
  f.signifier { Factory.next(:signifier) }
end
