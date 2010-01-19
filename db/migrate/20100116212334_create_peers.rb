class CreatePeers < ActiveRecord::Migration
  def self.up
    create_table :peers do |t|
      t.integer "player_id"
      t.integer "resolver_id"
      t.string   "signifier", :null => false

      t.timestamps
    end

    add_index "peers", "player_id", :name => "player_index"
    add_index "peers", "resolver_id", :name => "resolver_index"
    add_index "peers", "signifier", :name => "signifier_index"
  end

  def self.down
    drop_table :peers
  end
end
