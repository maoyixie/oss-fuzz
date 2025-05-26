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

# patch 1
# make -j$(nproc)

# patch 2
# sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-search.c
# sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-configure.c

# patch 3
# only apply sed once
grep -q 'int main2(int argc' ./src/clib-search.c || \
  sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-search.c
grep -q 'int main2(int argc' ./src/clib-configure.c || \
  sed 's/int main(int argc/int main2(int argc/g' -i ./src/clib-configure.c

# patch 4 - compile all deps/*.c to deps/*.o
find deps -name '*.c' -exec $CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c {} \;

# patch 5
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c src/clib-configure.c -o clib-configure.o
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c src/clib-search.c -o clib-search.o
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c src/common/clib-cache.c -o clib-cache.o
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c src/common/clib-settings.c -o clib-settings.o
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c src/common/clib-package.c -o clib-package.o
$CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__ \
  -DHAVE_PTHREADS=1 -pthread \
  -I./asprintf -I./deps -I./deps/asprintf \
  -c test/fuzzing/fuzz_manifest.c -o fuzz_manifest.o

# patch 6
# find . -name "*.o" -exec ar rcs fuzz_lib.a {} \;

# patch 7
# $CC $CFLAGS -Wno-unused-function -U__STRICT_ANSI__  \
# 	-DHAVE_PTHREADS=1 -pthread \
# 	-c src/common/clib-cache.c src/clib-configure.c\
#         src/common/clib-settings.c src/common/clib-package.c \
#         test/fuzzing/fuzz_manifest.c -I./asprintf -I./deps/ \
# 	-I./deps/asprintf

# patch 8
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE fuzz_manifest.o \
	-o $OUT/fuzz_manifest  clib-cache.o clib-configure.o clib-settings.o clib-package.o \
	$(find deps -name '*.o') \
	-I./deps/asprintf -I./deps -I./asprintf \
	-L/usr/lib/x86_64-linux-gnu -lcurl

echo "[libfuzzer]" > $OUT/fuzz_manifest.options
echo "detect_leaks=0" >> $OUT/fuzz_manifest.options
