#!/usr/bin/env bash

set -xeuo pipefail

rsync -ravp sites/ peaks1:/data/entrance/
