# KallistiOS Patch: Add GDFS Support to fs_iso9660

## Overview

This patch modifies the `fs_iso9660.c` filesystem implementation within the
KallistiOS (KOS) kernel. Its purpose is to add basic support for reading the
high-density area (second session) of GD-ROM discs, often referred to as GDFS
(Giga Disk File System), using the standard ISO9660 filesystem functions
(`iso_open`, `iso_read`, etc.).

This allows applications built with the patched KOS to access files stored in
the GD-ROM's high-density area without needing a separate GDFS driver or
implementation, provided the disc structure is compatible.

## Prerequisites

- A local copy of the KallistiOS source code.
- Git installed in your KOS development environment (e.g., within the Docker
  container or on your host system if building natively).
- A working KallistiOS build environment capable of compiling the KOS kernel
  (`make`).

## Instructions

Follow these steps to apply the patch and rebuild KOS:

1.  **Identify KOS Source Directory:** Determine the path to your KallistiOS
    source code. In many common setups (like the official KOS Docker image),
    this is `/opt/toolchains/dc/kos/`. Replace `<KOS_BASE_DIR>` in the commands
    below with your actual path.

2.  **Copy Patch File:** Copy the `fs_iso9660.patch` file into the root of your
    KOS source directory.

    ```bash
    cp fs_iso9660.patch <KOS_BASE_DIR>/
    ```

    _Example:_

    ```bash
    cp fs_iso9660.patch /opt/toolchains/dc/kos/
    ```

3.  **Navigate to KOS Directory:** Change your current directory to the KOS
    source directory.

    ```bash
    cd <KOS_BASE_DIR>
    ```

    _Example:_

    ```bash
    cd /opt/toolchains/dc/kos/
    ```

4.  **Apply the Patch:** Use Git to apply the patch file.

    ```bash
    git apply fs_iso9660.patch
    ```

    _Note:_ If this command reports errors or conflicts, it might mean the
    `fs_iso9660.c` file in your KOS version has diverged significantly from the
    one the patch was based on. You may need to resolve these conflicts manually
    or adapt the patch. Check `git status` for details after attempting to
    apply.

5.  **Rebuild KallistiOS:** Compile the modified KOS kernel and libraries.
    ```bash
    make
    ```
    _Tip:_ If you encounter unexpected build issues after patching, try cleaning
    the build first: `make clean && make`.

Once the `make` command completes successfully, KallistiOS will be rebuilt with
the GDFS support integrated into the `fs_iso9660` **filesystem implementation**.
Any applications subsequently compiled against this patched KOS will inherit
this capability.

## Patch Details

This patch achieves GDFS support within the existing ISO9660 filesystem
implementation through the following key modifications to `fs_iso9660.c`:

1.  **Global `disc_type` Variable:**

    - `+static int disc_type;`
    - A static global variable `disc_type` is introduced. This variable is
      intended to store the type of disc detected (e.g., `CD_ROM` or
      `CD_GDROM`), presumably set by the lower-level CD/GD-ROM hardware driver
      during initialization or status checks.

2.  **Conditional TOC Reading:**

    - `cdrom_read_toc(&toc, (disc_type == CD_GDROM))`
    - The call to `cdrom_read_toc` within the `init_percd` function is modified.
      The second parameter now conditionally passes `1` (true) if `disc_type`
      indicates a GD-ROM, and `0` (false) otherwise. This tells the underlying
      function to read the Table of Contents (TOC) for the _second session_
      (high-density area) when a GD-ROM is present, instead of the default first
      session.

3.  **Hardcoded Session Base for GD-ROM:**

    - `if(disc_type == CD_GDROM)`
    - `    session_base = 45150;`
    - `else if(!(session_base = cdrom_locate_data_track(&toc)))`
    - This is the core change. If the `disc_type` indicates a GD-ROM, the
      `session_base` variable (which represents the starting sector of the
      filesystem data) is explicitly set to `45150`. This is the standard
      starting logical block address (LBA) for the high-density data track on
      GD-ROMs.
    - If the disc is _not_ a GD-ROM, the original logic of finding the data
      track based on the (first session) TOC is used.

4.  **Removal of Local `disc_type`:**
    - The local `disc_type` variable within the `iso_vblank` function is
      removed, indicating reliance on the new global `disc_type` variable for
      status checks.

**In summary:** The patch leverages the existing ISO9660 parsing logic. By
detecting a GD-ROM, reading its second session TOC, and crucially, forcing the
filesystem's starting point (`session_base`) to the known beginning of the
high-density area (sector 45150), it allows the standard ISO9660 functions to
operate directly on the GDFS area as if it were a standard ISO9660 volume
starting at that offset.
