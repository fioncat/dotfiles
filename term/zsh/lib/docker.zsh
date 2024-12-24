clear_docker() {
  sudo docker rm -vf $(docker ps -aq)
  sudo docker rmi -f $(docker images -aq)
}
