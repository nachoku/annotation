class Url < ActiveRecord::Base
	belongs_to:search
	has_many:keywords
end
