class CreateResolvers < ActiveRecord::Migration
  def self.up
    create_table :resolvers do |t|
      t.string   "end_point", :null => false
      t.string   "public_key_prefix" # to facilitate db indexing
      t.text   "public_key", :null => false, :limit => 500

      t.timestamps
    end

    add_index "resolvers", "end_point", :name => "end_point_index"
    add_index "resolvers", "public_key_prefix", :name => "public_key_prefix_index"
# FIXME    add_index "players", "public_key", :name => "public_key_index", :length => 256
# Mysql::Error: BLOB/TEXT column 'public_key' used in key specification without a key length: CREATE  INDEX `public_key_index` ON `players` (`public_key`)
  end

  def self.down
    drop_table :resolvers
  end
end
