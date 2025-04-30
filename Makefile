TARGET := themeMenu.elf
BIN := 1ST_READ.BIN

EXT_SRCS := external/easing.c
TXR_SRCS := texture/block_pool.c texture/lru.c texture/txr_manager.c texture/dat_reader.c texture/serial_sanitize.c texture/simple_texture_allocator.c
BACKEND_SRCS := external/ini.c backend/gd_list.c backend/gdemu_sdk.c backend/gdemu_control.c backend/db_list.c
UI_MENUS := ui/ui_scroll.c ui/ui_line_large.c ui/ui_line_desc.c ui/ui_grid.c ui/global_settings.c ui/ui_menu_credits.c ui/theme_manager.c
UI_SRCS := ui/dc/font_bmf.c ui/dc/font_bitmap.c ui/dc/pvr_texture.c ui/dc/input.c ui/draw_kos.c ui/animation.c

SRCS := $(BACKEND_SRCS) $(UI_SRCS) $(UI_MENUS) $(TXR_SRCS) $(EXT_SRCS) vm2_api.c main.c
OBJS = $(subst .c,.o,$(SRCS))

CC := kos-cc
AS := kos-as
OBJCOPY := $(KOS_OBJCOPY)
RM := rm

CFLAGS := -I. -ffunction-sections -fdata-sections -std=c11 -O2 -g -Wno-unknown-pragmas -Wall -Wextra $(OPTIONS)
LDFLAGS := -Wl,--gc-sections -Xlinker -Map=output.map
LIBS := -lm ./lib/libcrayon_vmu.a

# devcontainer image vars
DEVCONTAINER_BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
DEVCONTAINER_IMAGE_URL ?= https://hub.docker.com/r/sbstnc/openmenu-dev
DEVCONTAINER_IMAGE_VERSION ?= 0.2.2
DEVCONTAINER_VCS_REF := $(shell git rev-parse --short HEAD)
DEVCONTAINER_VCS_URL := $(shell git config --get remote.origin.url)

all: clean-elf $(BIN)

%.o: %.s
	@echo $(AS) $<
	@$(CC) -x assembler-with-cpp $(CFLAGS) -c $< -o $@

%.o: %.c
	@echo $(CC) $<
	@$(CC) -c $< -o $@ $(CFLAGS)

$(TARGET): $(OBJS)
	@echo \> $(CC) -o $(TARGET)
	@$(CC) -o $(TARGET) $(LDFLAGS) $(CFLAGS) $(OBJS) $(LIBS) $(MAP)

$(BIN): $(TARGET)
	@echo $(notdir $(OBJCOPY)) -R .stack -O binary $< $@
	@$(OBJCOPY) -R .stack -O binary $< $@

# Run clang-format on source code
.PHONY: format
format:
	@echo "Running clang-format"
	@clang-format -i $(SRCS)

# Dry-run clang-format on source code to check for formatting errors
.PHONY: format-check
format-check:
	@echo "Checking clang-format"
	@clang-format --dry-run --Werror $(SRCS)

.PHONY: clean
clean:
	-@$(RM) -f $(TARGET) $(OBJS) $(BIN)

.PHONY: clean-elf
clean-elf:
	-@$(RM) -f $(TARGET)

.PHONY: run
run: $(TARGET)
	$(KOS_LOADER) $(TARGET)

.PHONY: devcontainer
devcontainer:
	cd docker && \
	docker build \
	  --platform linux/amd64 \
	  --build-arg BUILD_DATE="$(DEVCONTAINER_BUILD_DATE)" \
	  --build-arg IMAGE_URL="$(DEVCONTAINER_IMAGE_URL)" \
	  --build-arg IMAGE_VERSION="$(DEVCONTAINER_IMAGE_VERSION)" \
	  --build-arg VCS_REF="$(DEVCONTAINER_VCS_REF)" \
	  --build-arg VCS_URL="$(DEVCONTAINER_VCS_URL)" \
	  -t openmenu-dev:"$(DEVCONTAINER_IMAGE_VERSION)" \
	  -t openmenu-dev:latest \
	  . --load
