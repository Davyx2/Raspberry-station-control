#!/bin/bash

#launch client side video stream on port 5000 and 5001 (for cycled camera system)

gst-launch-1.0 udpsrc port=5000 ! application/x-rtp,encoding-name=JPEG,payload=26 ! rtpjpegdepay ! jpegdec ! autovideosink &
gst-launch-1.0 udpsrc port=5001 ! application/x-rtp,encoding-name=JPEG,payload=26 ! rtpjpegdepay ! jpegdec ! autovideosink &
python cameraCycleSend.py 6001 &
