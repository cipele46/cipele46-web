require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

def share_db_connection
  # Forces all threads to share the same connection. 
  # When Capybara is ran with Poltergeist, it runs the PhantomJS server
  # which runs in different thread. That thread is unable to see DB changes
  # from FactoryGirl without this helper.
  #
  # Read more about this on the awesome blog post from Plataformatec
  # http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
  #
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
end
share_db_connection
