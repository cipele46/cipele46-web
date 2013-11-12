$original_sunspot_session = Sunspot.session


module SunspotHelper
  def server_running?
    begin
      open("http://localhost:#{$sunspot.port}/")
      true
    rescue Errno::ECONNREFUSED
      # server not running yet
      false
    rescue OpenURI::HTTPError
      # getting a response so the server is running
      true
    end
  end

  def setup_solr
    unless $sunspot
      $sunspot = Sunspot::Rails::Server.new
      pid = fork do
        STDERR.reopen('/dev/null')
        STDOUT.reopen('/dev/null')
        $sunspot.run
      end
      # shut down the Solr server
      at_exit { Process.kill('TERM', pid) }
      # wait for solr to start
      print "Booting Sunspot server"
      until server_running?
        sleep 0.5
        print '.' 
      end
      puts "\nDone!"
    end
    Sunspot.session = $original_sunspot_session

    Ad.remove_all_from_index!
  end
end
