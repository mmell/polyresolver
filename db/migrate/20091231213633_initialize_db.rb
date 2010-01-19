class InitializeDb < ActiveRecord::Migration
  def self.up
    create_table "players", :force => true do |t|
      t.integer "community_id"
      t.string   "signifier"
      t.text   "public_key", :limit => 500
      t.text   "private_key", :null => true, :limit => 500
      t.string   "public_key_prefix" # to facilitate db indexing

      t.timestamps
    end
    
    add_index "players", "community_id", :name => "community_index"
    add_index "players", "signifier", :name => "signifier_index", :unique => true
    add_index "players", "public_key_prefix", :name => "public_key_prefix_index"
# FIXME    add_index "players", "public_key", :name => "public_key_index", :length => 256
# Mysql::Error: BLOB/TEXT column 'public_key' used in key specification without a key length: CREATE  INDEX `public_key_index` ON `players` (`public_key`)
    
    create_table "transports", :force => true do |t|
      t.integer :player_id
      t.string   "transport"
      t.string   "address", :null => true

      t.timestamps
    end

    add_index "transports", "player_id", :name => "player_id_index"
    add_index "transports", "transport", :name => "transport_index"

  end

  def self.down
    drop_table :players
    drop_table :transports
  end
end
