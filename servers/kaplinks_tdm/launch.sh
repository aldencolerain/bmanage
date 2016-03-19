sudo docker build --tag=bman .
sudo docker stop ktdm
sudo docker rm ktdm
sudo docker run -dit -p 7781-7782:7781-7782 -p 7781-7782:7781-7782/udp -p 5901:5900 -h ktdm --name ktdm bman
sudo docker exec -it ktdm bash