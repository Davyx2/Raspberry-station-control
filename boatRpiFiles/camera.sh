#!/bin/bash

#launch cameraCycle.py, which handles the cycled camera stream on port 5000 and 50001, based on controller input.
python cameraCycle.py 2046 6001 &
echo "launched cycled camera streams"