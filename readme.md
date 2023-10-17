How to use:

- Launch ec2 instance with ubuntu 22.0, run the following two commands:


- wget https://raw.githubusercontent.com/davyraittdevelops/setup_ec2_squid_proxy/main/install-squid-proxy-on-ubuntu.sh -O install-squid-proxy-on-ubuntu.sh


- sudo bash install-squid-proxy-on-ubuntu.sh
  

- Allow port 3128 in the security group incoming rules
  

- You now have a proxy, which you can use as publicIpOfEC2:3128


