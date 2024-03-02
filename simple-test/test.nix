{
  name = "Simple ping test";

  nodes = {
    # We don't need to add anything to the system configuration of the machines
    machine1 = {...}: {};
    machine2 = {...}: {};
  };

  # Inside of 'testScript', machine1 and machine2 are available as python objects
  # which have useful functions for performing tests.
  # Their name is also resolved in the virtual network.
  testScript = ''
    machine1.wait_for_unit("network-online.target")
    machine2.wait_for_unit("network-online.target")

    # Ping each machine
    machine1.succeed("ping -c 2 machine2")
    machine2.succeed("ping -c 2 machine1")
  '';
}
