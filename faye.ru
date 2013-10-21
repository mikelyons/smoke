require 'faye'

Faye::WebSocket.load_adapter('thin')

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

bayeux.on(:handshake) do |client_id|
  # get the active session for the present map

end

run bayeux