#!/bin/bash -eu
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

cd $SRC/kamailio

export CC_OPT="${CFLAGS}"
export LD_EXTRA_OPTS="${CFLAGS}"

sed -i 's/int main(/int main2(/g' ./src/main.c

export MEMPKG=sys
make Q=verbose || true
cd src
mkdir objects && find . -name "*.o" -exec cp {} ./objects/ \;
ar -r libkamilio.a ./objects/*.o
cd ../
$CC $CFLAGS -c ./misc/fuzz/fuzz_uri.c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE fuzz_uri.o -o $OUT/fuzz_uri \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/fuzz_parse_msg.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE fuzz_parse_msg.o -o $OUT/fuzz_parse_msg \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

#add
$CC $CFLAGS  ./misc/fuzz/get_src_address_socket.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE get_src_address_socket.o -o $OUT/get_src_address_socket \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/get_src_uri.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE get_src_uri.o -o $OUT/get_src_uri \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_content_disposition.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_content_disposition.o -o $OUT/parse_content_disposition \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_diversion_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_diversion_header.o -o $OUT/parse_diversion_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_from_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_from_header.o -o $OUT/parse_from_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_from_uri.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_from_uri.o -o $OUT/parse_from_uri \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_headers.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_headers.o -o $OUT/parse_headers \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_identityinfo_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_identityinfo_header.o -o $OUT/parse_identityinfo_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_msg.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_msg.o -o $OUT/parse_msg \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_pai_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_pai_header.o -o $OUT/parse_pai_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_privacy.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_privacy.o -o $OUT/parse_privacy \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_record_route_headers.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_record_route_headers.o -o $OUT/parse_record_route_headers \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_refer_to_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_refer_to_header.o -o $OUT/parse_refer_to_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_route_headers.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_route_headers.o -o $OUT/parse_route_headers \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_to_header.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_to_header.o -o $OUT/parse_to_header \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CC $CFLAGS  ./misc/fuzz/parse_to_uri.c -c \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE parse_to_uri.o -o $OUT/parse_to_uri \
    -DFAST_LOCK -D__CPU_i386 ./src/libkamilio.a \
    -I./src/ -I./src/core/parser -ldl -lresolv -lm