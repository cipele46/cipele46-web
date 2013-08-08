module Extensions
  module Ad
    module Status
      extend ActiveSupport::Concern

      STATES = { :pending => 1, :active => 2, :closed => 3 }

      included do
        def self.status
          STATES
        end
      end

      def set_status
        self.status = if supply?
                        self.class.status[:pending]
                      elsif demand?
                        activate
                      else
                        close
                      end
      end

      def close
        self.status = self.class.status[:closed]
      end

      def close!
        close
        save
      end

      def activate
        self.status = self.class.status[:active]
      end

      def activate!
        activate
        save
      end
    end
  end
end
