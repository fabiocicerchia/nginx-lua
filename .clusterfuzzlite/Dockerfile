FROM gcr.io/oss-fuzz-base/base-builder
COPY . $SRC/nginx-lua
WORKDIR $SRC/nginx-lua
COPY .clusterfuzzlite/build.sh $SRC/build.sh
