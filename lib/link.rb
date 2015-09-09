class Link
  def initialize(uri)
    @uri = uri
  end
  def on_website?(address, port)
    #puts "#{host_and_port} vs #{host_and_port_of(address)}"
    host_and_port == host_and_port_of(address, port)
  end
  private
  def host_and_port_of(address, port)
    address.include?(':') ? address : address + ":#{port}"
  end
  def host_and_port
    @uri.host + ':' + @uri.port.to_s
  end
end