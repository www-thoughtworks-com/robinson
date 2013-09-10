#!/bin/bash

time source devenv

set +e

echo "Running Specs"
time rake
