ip netns add nlb_client
ip link add name veth-nlbc-host type veth peer name veth-nlbc-ns
ip link set veth-nlbc-ns netns nlb_client
ip netns exec nlb_client ip addr add 10.10.10.2/24 dev veth-nlbc-ns

ip link set dev veth-nlbc-host up
ip netns exec nlb_client ip link set address 00:00:c8:12:12:12 dev veth-nlbc-ns
ip netns exec nlb_client ip link set veth-nlbc-ns up
ip netns exec nlb_client arp -s 10.10.10.1 00:00:00:11:22:41

ip netns add nlb_server1
ip link add name veth-nlbs1-host type veth peer name veth-nlbs1-ns
ip link set veth-nlbs1-ns netns nlb_server1
ip netns exec nlb_server1 ip addr add 10.10.10.1/24 dev veth-nlbs1-ns

ip link set dev veth-nlbs1-host up
ip netns exec nlb_server1 ip link set address 00:00:00:22:22:42 dev veth-nlbs1-ns
ip netns exec nlb_server1 ip link set veth-nlbs1-ns up

ip netns add nlb_server2
ip link add name veth-nlbs2-host type veth peer name veth-nlbs2-ns
ip link set veth-nlbs2-ns netns nlb_server2
ip netns exec nlb_server2 ip addr add 10.10.10.1/24 dev veth-nlbs2-ns

ip link set dev veth-nlbs2-host up
ip netns exec nlb_server2 ip link set address 00:00:00:22:22:43 dev veth-nlbs2-ns
ip netns exec nlb_server2 ip link set veth-nlbs2-ns up


ip link add br-nlb type bridge
brctl addif br-nlb veth-nlbc-host
brctl addif br-nlb veth-nlbs1-host
brctl addif br-nlb veth-nlbs2-host
brctl addif br-nlb tap-nlb-0

ip link set dev br-nlb up
ip link set dev tap-nlb-0 up

echo "envronment loaded, pass any key to unload."
read

brctl delif br-nlb tap-0
brctl delif br-nlb veth-nlbc-host
brctl delif br-nlb veth-nlbs1-host
brctl delif br-nlb veth-nlbs2-host
ip link del br-nlb type bridge

ip link delete dev veth-nlbs1-host 
ip link delete dev veth-nlbs2-host 
ip link delete dev veth-nlbc-host 
ip netns delete nlb_server1
ip netns delete nlb_server2
ip netns delete nlb_client

echo "envronment unloaded."
