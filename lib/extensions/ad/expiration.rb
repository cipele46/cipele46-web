module Extensions
  module Ad
    module Expiration
      # describes all the expiration logic
      
      VALID_FOR = 30 # in days

      def expires_at
        created_at + VALID_FOR.days
      end

      def closed?
        status == self.class.status[:closed] ||
          expired?
      end

      def active?
        !expired? && status == self.class.status[:active]
      end

      def pending?
        status == self.class.status[:pending]
      end

      private

        def expired?
          Time.current > (created_at + VALID_FOR.days)
        end
    end
  end
end
