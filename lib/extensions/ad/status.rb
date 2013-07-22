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
                        self.class.status[:active]
                      else
                        self.class.status[:closed]
                      end
      end
    end
  end
end
