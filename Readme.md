## Reference
This is a fork.

See Herles Great Work at: 
https://github.com/herlesupreeth/docker_open5gs


## Description
This repository contains configuration files for the srsRAN_4G project. Within the docker-compose.yml file, there is an environment variable that determines the specific usage mode of the srsRAN_4G project. In our use case, this variable can be set to either `ue_5g_zmq` or `ue_5g_disaggregation_zmq`, defining the operational mode for the user equipment (UE) components, whether in a monilothic gNB  or a disaggregated gNB configuration. Based on the value of this environment variable, the Dockerfile will be dynamically built to match the selected configuration.



