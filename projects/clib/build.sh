#!/bin/bash -eu
# Copyright 2020 Google Inc.
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

cd clib
make -j$(nproc)

sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-search.c
sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-configure.c

find . -name "*.o" -exec ar rcs fuzz_lib.a {} \;

$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__  \
	-DHAVE_PTHREADS=1 -pthread \
	-c src/common/clib-cache.c src/clib-configure.c \
        src/common/clib-settings.c src/common/clib-package.c \
        test/fuzzing/fuzz_manifest.c -I./asprintf -I./deps/ \
	-I./deps/asprintf

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE fuzz_manifest.o \
	-o $OUT/fuzz_manifest  clib-cache.o clib-configure.o clib-settings.o clib-package.o \
	-I./deps/asprintf -I./deps -I./asprintf \
	fuzz_lib.a -L/usr/lib/x86_64-linux-gnu -lcurl

echo "[libfuzzer]" > $OUT/fuzz_manifest.options
echo "detect_leaks=0" >> $OUT/fuzz_manifest.options

# aurora
export AFL_DIR=/home1/maoyi/aurora/evaluation/afl-fuzz
export OUT=/home1/maoyi/aurora/out

# fuzz
make clean || true
make -j$(nproc)

sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-search.c
sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-configure.c

# 生成静态库（跟你原先脚本一样）
find . -name "*.o" -exec ar rcs fuzz_lib.a {} +

CC=$AFL_DIR/afl-clang
CFLAGS="-O2 -g"

# 编译 fuzz_manifest.o
$CC $CFLAGS -DHAVE_PTHREADS=1 -pthread \
     -c test/fuzzing/fuzz_manifest.c \
     src/common/clib-cache.c src/clib-configure.c \
     src/common/clib-settings.c src/common/clib-package.c \
     -I./asprintf -I./deps -I./deps/asprintf

# 链接，可把 $LIB_FUZZING_ENGINE 去掉（只给 LibFuzzer 用）
$CC $CFLAGS fuzz_manifest.o clib-cache.o clib-configure.o \
    clib-settings.o clib-package.o fuzz_lib.a \
    -lcurl -pthread -o $OUT/fuzz_manifest_afl

# trace
make clean || true
make -j$(nproc)

sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-search.c
sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-configure.c

# 生成静态库（跟你原先脚本一样）
find . -name "*.o" -exec ar rcs fuzz_lib.a {}

CC=gcc
CFLAGS="-ggdb -O0"

# 编译 fuzz_manifest.o
gcc -ggdb -O0 -Wno-unused-function -U__STRICT_ANSI__ \
    -DHAVE_PTHREADS=1 -pthread \
    -c test/fuzzing/fuzz_manifest.c \
    src/clib-configure.c src/common/clib-cache.c \
    src/common/clib-settings.c src/common/clib-package.c \
    -I./asprintf -I./deps -I./deps/asprintf

# 链接，可把 $LIB_FUZZING_ENGINE 去掉（只给 LibFuzzer 用）
g++ -ggdb -O0 \
    fuzz_manifest.o clib-cache.o clib-configure.o clib-settings.o clib-package.o \
    -o $OUT/fuzz_manifest_trace fuzz_lib.a \
    -I./deps -I./deps/asprintf -I./asprintf \
    -L/usr/lib/x86_64-linux-gnu -lcurl