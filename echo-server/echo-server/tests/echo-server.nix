{
  self,
  pkgs,
}:
pkgs.nixosTest {
  name = "Echo Server Service Test";

  nodes = {
    # Machine 1: The server that will run the service
    server = {config, ...}: {
      imports = [self.nixosModules.echo-server];

      # Configure the service
      services.echo-server = {
        enable = true;
        port = 8222;
      };

      networking.firewall.allowedTCPPorts = [
        config.services.echo-server.port
      ];
    };

    # Machine 2: The client that will connect to the echo-server service
    # netcat (nc) is already available in the 'libressl' package.
    client = {...}: {};
  };

  globalTimeout = 20; # Test time limit

  testScript = {nodes, ...}: ''
    PORT = ${builtins.toString nodes.server.services.echo-server.port}
    TEST_STRING = "Test string. The server should echo it back."

    start_all()

    # Wait until VMs are up and the service is started.
    server.wait_for_unit("echo-server.service")
    server.wait_for_open_port(${builtins.toString nodes.server.services.echo-server.port})
    client.wait_for_unit("network-online.target")

    # The actual test sends an arbitrary string and expects to find it in the output
    output = client.succeed(f"echo '{TEST_STRING}' | nc -4 -N server {PORT}")
    assert TEST_STRING in output
  '';
}
