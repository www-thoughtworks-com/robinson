class Link
  def initialize(uri)
    @uri = uri
  end
  def on_website?(address)
    #puts "#{host_and_port} vs #{host_and_port_of(address)}"
    host_and_port == host_and_port_of(address)
  end
  private
  def host_and_port_of(address)
    address.include?(':') ? address : address + ':80'
  end
  def host_and_port
    @uri.host + ':' + @uri.port.to_s
  end
end