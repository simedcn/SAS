# Pattern matching in make files
#   $^ matches all the input dependencies
#   $< matches the first input dependency
#   $@ matches the output

CC=g++
GCC_VERSION_GE_43 := $(shell expr `g++ -dumpversion | cut -f2 -d.` \>= 3)

PUREGEV_ROOT = /opt/pleora/ebus_sdk
OPENCVDIR = /usr/include/opencv2/
CCFITSDIR = /usr/include/CCfits/
INCLUDE = -I$(OPENCVDIR) -I$(PUREGEV_ROOT)/include/ -I$(CCFITSDIR)

CFLAGS = -Wall $(INCLUDE) -Wno-unknown-pragmas
ifeq "$(GCC_VERSION_GE_43)" "1"
    CFLAGS += -std=gnu++0x
endif

IMPERX =-L$(PUREGEV_ROOT)/lib/		\
	-lPvBase             		\
	-lPvDevice          		\
	-lPvBuffer          		\
	-lPvPersistence      		\
	-lPvGenICam          		\
	-lPvStreamRaw        		\
	-lPvStream 
OPENCV = -lopencv_core -lopencv_highgui -lopencv_imgproc
THREAD = -lpthread
CCFITS = -lCCfits
ifeq "$(GCC_VERSION_GE_43)" "1"
    CCFITS += -lrt
endif

EXEC = sunDemo sbc_info sbc_shutdown sbc_info_reader sbc_shutdown_sender CTLCommandSimulator CTLSimulator SRVSimulator test_telemetry evaluate

default: sunDemo sbc_info sbc_shutdown

all: $(EXEC)

fullDemo: fullDemo.cpp processing.o utilities.o ImperxStream.o compression.o
	$(CC) $(CFLAGS) $^ -o $@ $(OPENCV) $(THREAD) $(IMPERX) $(CCFITS)

CTLCommandSimulator: CTLCommandSimulator.cpp UDPSender.o Command.o Packet.o lib_crc.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

CTLSimulator: CTLSimulator.cpp UDPReceiver.o Command.o Packet.o lib_crc.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

SRVSimulator: SRVSimulator.cpp UDPReceiver.o Telemetry.o Packet.o lib_crc.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

sunDemo: sunDemo.cpp Packet.o Command.o Telemetry.o UDPSender.o lib_crc.o UDPReceiver.o processing.o utilities.o ImperxStream.o compression.o types.o Transform.o TCPSender.o Image.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD) $(OPENCV) $(IMPERX) $(CCFITS) -pg

streamTest: streamTest.cpp processing.o utilities.o ImperxStream.o compression.o lib_crc.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD) $(OPENCV) $(IMPERX) $(CCFITS) -pg

AspectTest: AspectTest.cpp processing.o utilities.o compression.o
	$(CC) $(CFLAGS) $^ -o $@ $(OPENCV) $(CCFITS)

AspectVideo: AspectVideo.cpp processing.o utilities.o compression.o
	$(CC) $(CFLAGS) $^ -o $@ $(OPENCV) $(CCFITS)

test_telemetry: test_telemetry.cpp Telemetry.o Packet.o lib_crc.o UDPSender.o types.o
	$(CC) $(CFLAGS) $^ -o $@

evaluate: evaluate.cpp compression.o
	$(CC) $(CFLAGS) $^ -o $@ $(OPENCV) $(CCFITS)

#This executable need to be copied to /usr/local/bin/ after it is built
sbc_info: sbc_info.cpp Packet.o lib_crc.o UDPSender.o smbus.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

#This executable need to be copied to /usr/local/bin/ after it is built
sbc_shutdown: sbc_shutdown.cpp UDPReceiver.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

sbc_info_reader: sbc_info_reader.cpp UDPReceiver.o Packet.o lib_crc.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

sbc_shutdown_sender: sbc_shutdown_sender.cpp Packet.o lib_crc.o UDPSender.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

tmbin_reader: tmbin_reader.cpp Packet.o lib_crc.o Telemetry.o types.o
	$(CC) $(CFLAGS) $^ -o $@ $(THREAD)

#This pattern matching will catch all "simple" object dependencies
%.o: %.cpp %.hpp
	$(CC) -c $(CFLAGS) $< -o $@

smbus.o: smbus/smbus.c smbus/smbus.h
	$(CC) -c $(CFLAGS) $< -o $@

lib_crc.o: lib_crc/lib_crc.c lib_crc/lib_crc.h
	$(CC) -c $(CFLAGS) $< -o $@

Transform.o: Transform.cpp Transform.hpp spa/spa.c spa/spa.h
	$(CC) -c $(CFLAGS) $< -o $@

install: sunDemo sbc_info sbc_shutdown
	sudo systemctl stop sas
	sudo systemctl stop sbc_info
	sudo systemctl stop sbc_shutdown
	sudo cp sunDemo /usr/local/bin/sunDemo.runtime
	sudo cp sbc_info /usr/local/bin/sbc_info.runtime
	sudo cp sbc_shutdown /usr/local/bin/sbc_shutdown.runtime
	sudo systemctl start sbc_shutdown
	sudo systemctl start sbc_info
	sudo systemctl start sas

clean:
	rm -rf *.o *.out $(EXEC)