sudo docker build --tag=bman .
sudo docker stop boring
sudo docker rm boring
sudo docker run -dit -p 7778-7779:7778-7779 -p 7778-7779:7778-7779/udp -p 5900:5900 -h boring --name boring bman
sudo docker exec -it boring bash -c "bash bmanage.sh start && bash"