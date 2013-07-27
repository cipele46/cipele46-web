$original_sunspot_session = Sunspot.session

module SunspotHelper
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
      sleep 5
    end
    Sunspot.session = $original_sunspot_session

    Ad.remove_all_from_index!
  end
end


