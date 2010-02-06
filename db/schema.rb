# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100206193045) do

  create_table "peers", :force => true do |t|
    t.integer  "player_id"
    t.integer  "resolver_id"
    t.string   "signifier",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "peers", ["player_id"], :name => "player_index"
  add_index "peers", ["resolver_id"], :name => "resolver_index"
  add_index "peers", ["signifier"], :name => "signifier_index"

  create_table "players", :force => true do |t|
    t.string   "signifier"
    t.text     "public_key"
    t.text     "private_key"
    t.string   "public_key_prefix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["public_key_prefix"], :name => "public_key_prefix_index"
  add_index "players", ["signifier"], :name => "signifier_index", :unique => true

  create_table "resolvers", :force => true do |t|
    t.string   "end_point",         :null => false
    t.string   "public_key_prefix"
    t.text     "public_key",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resolvers", ["end_point"], :name => "end_point_index"
  add_index "resolvers", ["public_key_prefix"], :name => "public_key_prefix_index"

  create_table "transports", :force => true do |t|
    t.integer  "player_id"
    t.string   "transport"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transports", ["player_id"], :name => "player_id_index"
  add_index "transports", ["transport"], :name => "transport_index"

end
