# lightbar_fx - GoldHEN PS4 Lightbar FX Plugin

DEBUG_FLAGS = -D__FINAL__=1
LOG_TYPE = -D__USE_PRINTF__
BUILD_TYPE = _final

ifeq ($(DEBUG),1)
    DEBUG_FLAGS = -D__FINAL__=0
    BUILD_TYPE = _debug
endif

TYPE         := $(BUILD_TYPE)
FINAL        := $(DEBUG_FLAGS)
BUILD_FOLDER := $(shell pwd)/../../bin/plugins
OUTPUT_PRX   := $(shell basename $(CURDIR))
TARGET       := $(BUILD_FOLDER)/prx$(TYPE)/$(OUTPUT_PRX)
TARGET_ELF   := $(BUILD_FOLDER)/elf$(TYPE)/$(OUTPUT_PRX)
TARGETSTUB   := $(OUTPUT_PRX).so

# Libraries linked into the ELF.
LIBS := -lSceLibcInternal -lGoldHEN_Hook -lkernel -lSceSysmodule -lScePad -lSceUserService -lm

EXTRAFLAGS := $(DEBUG_FLAGS) $(LOG_TYPE) -fcolor-diagnostics -Wall

# Root vars
TOOLCHAIN     := $(OO_PS4_TOOLCHAIN)
GH_SDK        := $(GOLDHEN_SDK)
PROJDIR       := ../$(shell basename $(CURDIR))/source
INTDIR        := ../$(shell basename $(CURDIR))/build
INCLUDEDIR    := ../$(shell basename $(CURDIR))/include
COMMON_DIR    := ../../common
CONFIG_DIR    := ../gamepad_helper

# Define objects to build
CFILES      := $(wildcard $(PROJDIR)/*.c)
OBJS        := $(patsubst $(PROJDIR)/%.c, $(INTDIR)/%.o, $(CFILES))

# Define final C/C++ flags
CFLAGS      := $(FINAL) --target=x86_64-pc-freebsd12-elf -fPIC -funwind-tables -c $(EXTRAFLAGS) -isysroot $(TOOLCHAIN) -isystem $(TOOLCHAIN)/include -I$(GH_SDK)/include -I$(INCLUDEDIR) -I$(COMMON_DIR) -I$(CONFIG_DIR)/include $(O_FLAG)
LDFLAGS     := -m elf_x86_64 -pie --script $(TOOLCHAIN)/link.x -e _init --eh-frame-hdr -L$(TOOLCHAIN)/lib -L$(GH_SDK) $(LIBS)

# Create the intermediate directory
_unused     := $(shell mkdir -p $(INTDIR))

# Check for linux vs macOS
UNAME_S     := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
        CC      := clang
        LD      := ld.lld
        CDIR    := linux
endif
ifeq ($(UNAME_S),Darwin)
        CC      := /usr/local/opt/llvm/bin/clang
        LD      := /usr/local/opt/llvm/bin/ld.lld
        CDIR    := macos
endif

$(TARGET): $(INTDIR) $(OBJS)
	$(LD) $(GH_SDK)/build/crtprx.o $(INTDIR)/*.o -o $(TARGET_ELF).elf $(LDFLAGS)
	$(TOOLCHAIN)/bin/$(CDIR)/create-fself -in=$(TARGET_ELF).elf -out=$(TARGET_ELF).oelf --lib=$(TARGET).prx --paid 0x3800000000000011

$(INTDIR)/%.o: $(PROJDIR)/%.c
	$(CC) $(CFLAGS) -o $@ $<

plugin_common:
	$(CC) $(CFLAGS) -o $(INTDIR)/plugin_common.o $(COMMON_DIR)/plugin_common.c

config:
	$(CC) $(CFLAGS) -o $(INTDIR)/config.o $(CONFIG_DIR)/source/config.c

build-info:
	$(shell echo "#define GIT_COMMIT \"$(shell git rev-parse HEAD 2>/dev/null || echo unknown)\"" > $(COMMON_DIR)/git_ver.h)
	$(shell echo "#define GIT_VER \"$(shell git branch --show-current 2>/dev/null || echo unknown)\"" >> $(COMMON_DIR)/git_ver.h)
	$(shell echo "#define GIT_NUM $(shell git rev-list HEAD --count 2>/dev/null || echo 0)" >> $(COMMON_DIR)/git_ver.h)
	$(shell echo "#define BUILD_DATE \"$(shell date '+%b %d %Y @ %T')\"" >> $(COMMON_DIR)/git_ver.h)

.PHONY: clean
.DEFAULT_GOAL := all

all: build-info plugin_common config $(TARGET)

clean:
	rm -rf $(TARGET) $(TARGETSTUB) $(INTDIR) $(OBJS)
