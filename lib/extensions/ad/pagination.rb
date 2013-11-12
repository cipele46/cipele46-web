module Extensions
  module Ad
    module Pagination
      extend ActiveSupport::Concern

      PER_PAGE  = 20
      PER_PAGE_API = 15

      included do
        def self.per_page(endpoint = :web)
          case endpoint
          when :api then PER_PAGE_API
          else PER_PAGE
          end
        end
      end
    end
  end
end
