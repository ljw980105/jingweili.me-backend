#!/bin/bash

rm -rf .build
vapor build
vapor run &> output.log &
