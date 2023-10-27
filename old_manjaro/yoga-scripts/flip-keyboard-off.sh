#!/bin/bash
KB_DEVICE_ID=15
KB_DEVICE_SLAVE_ID=3
xinput float $KB_DEVICE_ID
sleep 5
xinput reattach $KB_DEVICE_ID $KB_DEVICE_SLAVE_ID
