ip netns add nlb_client
ip link add name veth-nlbc-host type veth peer name veth-nlbc-ns
ip link set veth-nlbc-ns netns nlb_client
ip netns exec nlb_client ip addr add 10.10.10.2/25 dev veth-nlbc-ns

ip link set dev veth-nlbc-host up
ip netns exec nlb_client ip link set address 00:00:c8:12:12:12 dev veth-nlbc-ns
ip netns exec nlb_client arp -s 10.10.10.1 00:00:00:11:22:41
ip netns exec nlb_client ip link set veth-nlbc-ns up

ip netns add nlb_server
ip link add name veth-nlbs-host type veth peer name veth-nlbs-ns
ip link set veth-nlbs-ns netns nlb_server
ip netns exec nlb_server ip addr add 10.10.10.1/25 dev veth-nlbs-ns

ip link set dev veth-nlbs-host up
ip netns exec nlb_server ip link set address 00:00:00:22:22:42 dev veth-nlbs-ns
ip netns exec nlb_server ip link set veth-nlbs-ns up

ip netns add nlb_server2
ip link add name veth-nlbs2-host type veth peer name veth-nlbs2-ns
ip link set veth-nlbs2-ns netns nlb_server2
ip netns exec nlb_server2 ip addr add 10.10.10.1/25 dev veth-nlbs2-ns

ip link set dev veth-nlbs2-host up
ip netns exec nlb_server2 ip link set address 00:00:00:22:22:43 dev veth-nlbs2-ns
ip netns exec nlb_server2 ip link set veth-nlbs2-ns up


ip link add br-test type bridge
brctl addif br-test veth-nlbc-host
brctl addif br-test veth-nlbs-host
brctl addif br-test veth-nlbs2-host
brctl addif br-test tap-0

ip link set dev br-test up
ip link set dev tap-0 up

echo "envronment loaded, pass any key to unload."
read

brctl delif br-test tap-0
brctl delif br-test veth-nlbc-host
brctl delif br-test veth-nlbs-host
brctl delif br-test veth-nlbs2-host
ip link del br-test type bridge

ip link delete dev veth-nlbs-host 
ip link delete dev veth-nlbs2-host 
ip link delete dev veth-nlbc-host 
ip netns delete nlb_server
ip netns delete nlb_server2
ip netns delete nlb_client

echo "envronment unloaded."
