class DropCommunityConcept < ActiveRecord::Migration
  def self.up
    remove_column :players, :community_id
  end

  def self.down
  end
end
