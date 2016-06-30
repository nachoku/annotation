class Cluster < ActiveRecord::Base
	attr_accessor :url_id, :count
	validates_uniqueness_of :url_id
end
