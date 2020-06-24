#!/bin/bash

swift build
.build/debug/Run &> output.log &

# rm -rf .build
# vapor build
# vapor run &> output.log &
