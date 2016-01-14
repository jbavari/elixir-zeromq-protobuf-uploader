#!/bin/bash
START=$(date +%s)
echo "Starting bombardment"
# do something
# start your script work here
mix run -e Zmq2Client.zmq & mix run -e Zmq2Client.zmq & mix run -e Zmq2Client.zmq & mix run -e Zmq2Client.zmq && fg
# your logic ends here
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
