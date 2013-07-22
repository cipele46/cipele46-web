module Extensions
  module User
    module Naming
      def name
        "#{self.first_name} #{self.last_name}"
      end
    end
  end
end
