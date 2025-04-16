# openmenu

A fork of megavolt85's openMenu software, a replacement menu for the GDEMU
optical drive emulator for the Sega Dreamcast. This version is built using the
KallistiOS (KOS) SDK.

## Table of Contents

- Prerequisites (Native Build)
- Compilation (Native Build)
- Development using Dev Containers
  - Using the Pre-built Image (Recommended)
  - Building the Dev Container Image Locally
- Usage
- Contributing
- License
- Acknowledgements

## Prerequisites (Native Build)

Building `openmenu` natively (outside of the provided Dev Container) requires a
specific setup of the KallistiOS SDK and toolchain. **This is complex and the
recommended method is using the Dev Container.**

If you wish to proceed natively, you will need:

1.  **Git:** For cloning the repository.
2.  **Standard Build Tools:** `make`, a C compiler (GCC is typically used).
3.  **KallistiOS (KOS) SDK & Toolchain:**
    - You need a specific version of KallistiOS based on commit
      `ae3d5ec3ed7bbc0f0ea8fdd9f8d25e68ba7e8673` (as used in the `Dockerfile`).
    - The KOS source tree must be patched: The file `kos_patch/fs_iso9660.c`
      from this repository needs to replace the original
      `kos/kernel/arch/dreamcast/fs/fs_iso9660.c` within the KOS source _before_
      building KOS itself (see `Dockerfile`).
    - You need to build the `dc-chain` toolchain (SH4 cross-compiler, etc.) and
      then KOS itself.
    - Instructions for setting up a KOS environment can be found in the official
      KOS documentation or guides like the Dreamcast Development Wiki. The
      process used in the project's `Dockerfile` (`docker/Dockerfile`) can also
      serve as a reference.
    - Crucially, you must have the KOS environment variables sourced (typically
      via `source /path/to/kos/environ.sh`) in your shell before attempting to
      compile `openmenu`.

## Compilation (Native Build)

**Note:** Ensure your KallistiOS environment is correctly set up and sourced in
your current shell session before running these commands.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/sbstnc/openmenu.git
    cd openmenu
    ```

2.  **Compile the project:**

    ```bash
    make
    ```

    This will use the `kos-cc` compiler and associated tools defined by your KOS
    environment.

3.  **Output:** The compiled binary ready for the GDEMU will be `1ST_READ.BIN`.
    An ELF file (`themeMenu.elf`) is also generated, which might be useful for
    debugging or emulators.

4.  **Clean:**
    ```bash
    make clean
    ```

## Development using Dev Containers

This project includes a Dev Container configuration for a consistent and
ready-to-use development environment, including the correctly patched KallistiOS
SDK. This is the **recommended** way to build and develop `openmenu`.

**Prerequisites:**

- Docker Desktop (or a compatible Docker engine).
- Visual Studio Code.
- The Dev Containers extension installed in VS Code.

### Using the Pre-built Image (Recommended)

A pre-built image containing the necessary environment is available on Docker
Hub (`sbstnc/openmenu-dev:0.1.0` as specified in
`.devcontainer/devcontainer.json`).

1.  Clone the repository:
    ```bash
    git clone https://github.com/sbstnc/openmenu.git
    cd openmenu
    ```
2.  Open the cloned repository folder in VS Code:
    ```bash
    code .
    ```
3.  VS Code should detect the `.devcontainer` configuration and prompt you:
    _"Folder contains a Dev Container configuration file. Reopen folder to
    develop in a container?"_.
4.  Click **"Reopen in Container"**. VS Code will pull the pre-built
    `sbstnc/openmenu-dev` image from Docker Hub (if you don't have it locally)
    and start the container.
5.  If you don't see the prompt, open the Command Palette (`Ctrl+Shift+P` or
    `Cmd+Shift+P`) and run the **"Dev Containers: Reopen in Container"**
    command.
6.  Once the container is running, you can open a terminal within VS Code
    (`Terminal > New Terminal`). The KOS environment is already set up. You can
    compile the project directly:
    ```bash
    source /opt/toolchains/dc/kos/environ.sh && make
    ```

### Building the Dev Container Image Locally

If you prefer not to use the pre-built image from Docker Hub or want to build it
yourself:

1.  Ensure Docker is running.
2.  Clone the repository:
    ```bash
    git clone https://github.com/sbstnc/openmenu.git
    cd openmenu
    ```
3.  Run the make target to build the image:
    ```bash
    make devcontainer
    ```
    **Warning:** This process downloads and compiles the entire KallistiOS
    toolchain and SDK. It can take a significant amount of time (potentially
    hours) depending on your machine and network speed.
4.  Once the build completes successfully, you will have a local Docker image
    tagged `openmenu-dev:latest` (and potentially `openmenu-dev:<version>`).
5.  **Update Dev Container Configuration:** Before reopening in VS Code, edit
    the `.devcontainer/devcontainer.json` file. Change the `image` property from
    `"sbstnc/openmenu-dev:0.1.0"` to `"openmenu-dev:latest"` (or the specific
    version tag you built, e.g., `"openmenu-dev:0.1.0"` if you built that tag
    locally).

    ```diff
    --- a/.devcontainer/devcontainer.json
    +++ b/.devcontainer/devcontainer.json
    @@ -1,5 +1,5 @@
     {
       "name": "Dreamcast Dev",
    -  "image": "sbstnc/openmenu-dev:0.1.0",
    +  "image": "openmenu-dev:latest",
       "runArgs": [
         "--userns=keep-id"
       ],

    ```

6.  Now, open the project folder in VS Code (`code .`) and use the **"Dev
    Containers: Reopen in Container"** command. VS Code will use your locally
    built image.
7.  Compile within the container as described in the previous section:
    ```bash
    make
    ```

## Usage

The primary output is `1ST_READ.BIN`. This file is intended to replace the
existing `1ST_READ.BIN` within the `tools/openMenu/menu_data` directory of your
GDMENU Card Manager installation. After replacing the file, use the GDMENU Card
Manager tool to prepare your SD card for the GDEMU.

You can potentially run the `themeMenu.elf` file using a Dreamcast emulator that
supports ELF loading, or via `dc-load-ip` / `dc-tool` if you have the necessary
hardware setup (requires `KOS_LOADER` environment variable to be set, see
`Makefile.mk`'s `run` target).

## Contributing

Found a bug or have a suggestion? Please open an issue on the GitHub Issues
page.

## License

The core code of this project is licensed under the Modified BSD License - see
the `LICENSE.md` file for details.

The included Crayon_VMU library (`lib/libcrayon_vmu.a`) is licensed under the
BSD 3-Clause License - see the `LICENSE.Crayon_VMU.md` file for details.

## Acknowledgements

This project builds upon the work of many individuals in the Dreamcast homebrew
community. Special thanks to:

- **HaydenKow:** For starting the original openMenu project.
- **megavolt85:** For the version of openMenu this fork is based on, and work on
  the GDEMU SDK aspects.
- **mrneo240:** For maintaining the upstream fork.
- **u/westhinksdifferent:** For the UI design mockups.
- **FlorreW, hasnopants, Roareye:** For their work on the Metadata Database.
- **sonik-br:** For the GDMENUCardManager tool.
- **protofall:** For the Crayon_VMU library.
- **ReveriePass:** For custom boxart contributions.
- **marky-b-1986:** For theming ideas.
- **The KallistiOS team:** For the essential Dreamcast SDK.
