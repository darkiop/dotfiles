#!/bin/bash

find . -name '*.sh' | xargs git update-index --chmod=+x

# EOF
