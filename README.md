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

1.  **Git:** For cloning the repository and applying patches.
2.  **CMake:** Version 3.19 or higher.
3.  **Ninja Build System:** CMake is configured to use Ninja by default in the
    presets.
4.  **KallistiOS (KOS) SDK & Toolchain:**
    - You need the **`v2.1.x` branch** of KallistiOS (as used in the
      `Dockerfile`). You can check out a specific tag or commit within that
      branch if needed.
    - The KOS source tree must be patched **before building KOS itself**: The
      patch file `docker/kos_patch/fs_iso9660.patch` from this repository needs
      to be applied to the KOS source tree using `git apply`. Detailed
      instructions for applying this patch can be found in
      `docker/kos_patch/README.md`. This patch adds necessary GDFS support to
      the `fs_iso9660` filesystem driver.
    - You need to build the `dc-chain` toolchain (SH4 cross-compiler, etc.) and
      then KOS itself (after patching).
    - Instructions for setting up a KOS environment can be found in the official
      KOS documentation or guides like the Dreamcast Development Wiki. The
      process used in this project's `Dockerfile` (`docker/Dockerfile`) can also
      serve as a reference for building KOS `v2.1.x` and applying the patch.
    - Crucially, you must have the KOS environment variables sourced (typically
      via `source /path/to/kos/environ.sh`) in your shell before attempting to
      compile `openmenu`.

## Compilation (Native Build)

**Note:** Ensure your KallistiOS environment (using the `v2.1.x` branch, patched
as described above) is correctly set up and sourced in your current shell
session before running these commands. Specifically, the `KOS_CMAKE_TOOLCHAIN`
environment variable must be set.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/sbstnc/openmenu.git
    cd openmenu
    ```

2.  **Compile openmenu:**

    ```bash
    # Configure using the 'dc-release' preset
    cmake --preset dc-release
    # Build using the 'dc-release' preset configuration
    cmake --build --preset dc-release
    ```

    This will use the `kos-cc` compiler and associated tools defined by your KOS
    environment.

3.  **Output:** The compiled binary ready for the GDEMU will be `1ST_READ.BIN`.
    An ELF file (`openmenu.elf`) is also generated, which might be useful for
    debugging or emulators.

4.  **Clean:**
    ```bash
    cmake --build --preset dc-release --target clean
    ```

## Development using Dev Containers

This project includes a Dev Container configuration for a consistent and
ready-to-use development environment. It includes the correctly patched
KallistiOS SDK (**`v2.1.x` branch** with the `fs_iso9660.patch` applied). This
is the **recommended** way to build and develop `openmenu`.

**Prerequisites:**

- Docker Desktop (or a compatible Docker engine).
- Visual Studio Code.
- The Dev Containers extension installed in VS Code.

### Using the Pre-built Image (Recommended)

A pre-built image containing the necessary environment is available on Docker
Hub (`sbstnc/openmenu-dev:0.2.2` as specified in
`.devcontainer/devcontainer.json`). This image contains KOS `v2.1.x` patched as
required.

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
    # Configure using the 'dc-release' preset
    cmake --preset dc-release
    # Build using the 'dc-release' preset configuration
    cmake --build --preset dc-release
    ```

### Building the Dev Container Image Locally

If you prefer not to use the pre-built image from Docker Hub or want to build it
yourself (e.g., to incorporate newer KOS updates from the `v2.1.x` branch or
modify the build process):

1.  Ensure Docker is running.
2.  Clone the repository:
    ```bash
    git clone https://github.com/sbstnc/openmenu.git
    cd openmenu
    ```
3.  Run the make target to build the image:
    ```bash
    cd docker
    ./build.sh
    ```
    **Warning:** This process downloads and compiles the entire KallistiOS
    toolchain and SDK (from the `v2.1.x` branch) and applies the necessary
    patch. It can take a significant amount of time (potentially hours)
    depending on your machine and network speed.
4.  Once the build completes successfully, you will have a local Docker image
    tagged `openmenu-dev:latest` (and potentially `openmenu-dev:<version>`).
5.  **Update Dev Container Configuration:** Before reopening in VS Code, edit
    the `.devcontainer/devcontainer.json` file. Change the `image` property from
    `"sbstnc/openmenu-dev:0.2.2"` to `"openmenu-dev:latest"` (or the specific
    version tag you built, e.g., `"openmenu-dev:0.2.2"` if you built that tag
    locally).

    ```diff
    --- a/.devcontainer/devcontainer.json
    +++ b/.devcontainer/devcontainer.json
    @@ -1,5 +1,5 @@
     {
       "name": "Dreamcast Dev",
    -  "image": "sbstnc/openmenu-dev:0.2.2",
    +  "image": "openmenu-dev:latest", // Or your locally built tag
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

## Compiling in Docker Container without VSCode Dev Container

1.  Follow the instructions in [**Building the Dev Container Image Locally**](#building-the-dev-container-image-locally) up to
    step 4
2.  Verify that the Docker image exists
    ```bash
    docker images
    ```
3.  Build the Docker container
    ```bash
    docker run --name openmenu-dev -it -d -v ./..:/src:rw openmenu-dev
    ```
4.  Open bash in container
    ```bash
    docker exec -it openmenu-dev bash
    ```
5.  Change to source directory in the container
    ```bash
    cd /src
    ```
6.  Build the application
    ```bash
    # Configure using the 'dc-release' preset
    cmake --preset dc-release
    # Build using the 'dc-release' preset configuration
    cmake --build --preset dc-release
    ```

## Usage

The primary output is `1ST_READ.BIN`. This file is intended to replace the
existing `1ST_READ.BIN` within the `tools/openMenu/menu_data` directory of your
GDMENU Card Manager installation. After replacing the file, use the GDMENU Card
Manager tool to prepare your SD card for the GDEMU.

You can potentially run the `openmenu.elf` file using a Dreamcast emulator that
supports ELF loading, or via `dc-load-ip` / `dc-tool` if you have the necessary
hardware setup (requires `KOS_LOADER` environment variable to be set, see
`Makefile.mk`'s `run` target).

## Contributing

Found a bug or have a suggestion? Please open an issue on the GitHub Issues
page.

## License

The core code of this project is licensed under the Modified BSD License - see
the `LICENSE.md` file for details.

External libraries included in the `external` directory have their own licenses.
Please refer to the respective directories for details.

## Acknowledgements

This project builds upon the work of many individuals in the Dreamcast homebrew
community. Special thanks to:

- **HaydenKow (mrneo240):** For starting the original openMenu project.
- **megavolt85:** For the version of openMenu this fork is based on, and work on
  the GDEMU SDK aspects.
- **u/westhinksdifferent:** For the UI design mockups.
- **FlorreW, hasnopants, Roareye:** For their work on the Metadata Database.
- **sonik-br:** For the GDMENUCardManager tool.
- **protofall:** For the Crayon_VMU library.
- **ReveriePass:** For custom boxart contributions.
- **marky-b-1986:** For theming ideas.
- **The KallistiOS team:** For the essential Dreamcast SDK.
