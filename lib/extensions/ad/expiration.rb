module Extensions
  module Ad
    module Expiration
      # describes all the expiration logic
      
      VALID_FOR = 30 # in days

      def expires_at
        created_at + VALID_FOR.days
      end

      def closed?
        Time.current > (created_at + VALID_FOR.days)
      end
    end
  end
end
