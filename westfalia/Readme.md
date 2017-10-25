Westfalia is a simple purposed Jenkins that can be propped up on an ubuntu server running docker/compose.
The configuration is done using a docker container that populates the security tokens and configures the jenkins.

To setup docker/compose ... run the following two commands:
./config/install-docker-and-compose.sh
./config/add-user-docker-group.sh



docker-compose up
docker-compose start config

once config runs and terminates... the pieces running in the docker-compose.yaml file will continue running.

