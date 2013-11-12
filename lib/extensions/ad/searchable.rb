module Extensions
  module Ad
    module Searchable 
      extend ActiveSupport::Concern

      included do
        def self.search(options = {})
          AdFilter.new(options).search.results
        end

        searchable do
          text :title, boost: 4.0
          text :description, boost: 2.0
          text :phone
          text :category do
            category.name
          end
          text :city do
            city.name
          end
          text :region do 
            city.region.name 
          end
          integer :region_id do
            city.region_id
          end
          integer :category_id
          integer :ad_type
          integer :status
          integer :user_id
          time :created_at
        end
      end
    end
  end
end
