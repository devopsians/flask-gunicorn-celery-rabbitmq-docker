#!/bin/bash

sudo docker system prune -a
sudo docker container stop $(sudo docker container ls -aq)
sudo docker container rm $(sudo docker container ls -aq)
sudo docker rmi $(sudo docker images -aq)
sudo docker volume prune