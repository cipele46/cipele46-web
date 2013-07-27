module Extensions
  module Ad
    module Type
      extend ActiveSupport::Concern

      STATES  = { :supply => 1, :demand => 2 }

      included do
        class << self
          def type
            STATES
          end

          def receiving
            demand
          end

          def giving
            supply
          end
        end
      end

      def supply?
        ad_type.to_i == self.class.type[:supply].to_i
      end

      def demand?
        ad_type.to_i == self.class.type[:demand].to_i
      end

      def type_name
        self.class.type.invert[ad_type]
      end

      def type_name_css
        case type_name
        when :supply then :giving
        when :demand then :receiving
        end
      end
    end
  end
end
