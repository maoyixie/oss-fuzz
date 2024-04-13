TARGET=Fuzzer

#File
CLIENTEXE=FuzzClient
SERVEREXE=FuzzServer
#add
BITSEXE=modbus_read_bits
REGISTERSEXE=modbus_read_registers

#Compiler Flags
SET=cd ../ &&
INC=-I../src/
LIB=../src/libmodbus.la
EXTCFLAGS= -Wall -Wextra
LIBTOOL=libtool --mode=link --tag=CXX

all: $(TARGET)

#SETUP
INIT:
	$(SET) ./autogen.sh

CONF:
	$(SET) ./configure --disable-shared CC=$(CC) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

MAKEALL:
	$(SET) make -j$(nproc)

CPFILE:
	cp ../tests/unit-test.h .

$(TARGET): INIT CONF MAKEALL CPFILE
	$(CC) $(EXTCFLAGS) $(CFLAGS) $(INC) -c $(CLIENTEXE).c
	$(LIBTOOL) $(CXX) $(LDFLAGS) $(CFLAGS) $(LIB) $(LIB_FUZZING_ENGINE) $(CLIENTEXE).o -o $(CLIENTEXE)

	$(CC) $(EXTCFLAGS) $(CFLAGS) $(INC) -c $(SERVEREXE).c
	$(LIBTOOL) $(CXX) $(LDFLAGS) $(CFLAGS) $(LIB) $(LIB_FUZZING_ENGINE) $(SERVEREXE).o -o $(SERVEREXE)
	

	$(CC) $(EXTCFLAGS) $(CFLAGS) $(INC) -c $(BITSEXE).c
	$(LIBTOOL) $(CXX) $(LDFLAGS) $(CFLAGS) $(LIB) $(LIB_FUZZING_ENGINE) $(BITSEXE).o -o $(BITSEXE)

	$(CC) $(EXTCFLAGS) $(CFLAGS) $(INC) -c $(REGISTERSEXE).c
	$(LIBTOOL) $(CXX) $(LDFLAGS) $(CFLAGS) $(LIB) $(LIB_FUZZING_ENGINE) $(REGISTERSEXE).o -o $(REGISTERSEXE)

clean:
	rm $(CLIENTEXE) $(SERVEREXE) $(BITSEXE) $(REGISTERSEXE) *.o

.PHONY: all clean
