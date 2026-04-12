#!/bin/bash -eu

# Build the fuzz target for nginx configuration validation
$CC $CFLAGS $LIB_FUZZING_ENGINE \
    $SRC/nginx-lua/.clusterfuzzlite/fuzz_config_parser.c \
    -o $OUT/fuzz_config_parser
