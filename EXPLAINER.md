# Parshwa EMR Release Publishing Guide

This folder contains the automated single-click release tool designed to build the EMR server and publish update packages to the GitHub releases repository.

## Files

### 1. `publish-release.bat`
This is the automated release batch script. Double-clicking this script will execute the following sequence:
- **Build Rust App**: Compiles the latest Rust backend in release mode (`cargo build --release`).
- **Compile Setup Installer**: Automatically updates the SemVer release version metadata and compiles the new Inno Setup installer executable.
- **Sync Files**: Cleans up older installer setups and copies the fresh `version.json`, `bin/Parshwa_EMR.exe`, and the new `ParshwaEMR-Setup-*.exe` to the local releases repository.
- **Git Push**: Automatically stages the new binary and installer updates, commits them under the generated release version tag, and pushes the changes live to GitHub.

---

## How to Publish a New Update

1. **Verify Your Changes**: Ensure your source code is functional and compiles locally.
2. **Double-Click `publish-release.bat`**: Run the script from this folder.
3. **Monitor the Terminal**: The terminal will display progress as it builds, packages, and pushes files.
4. **Push Success**: The terminal will display `[SUCCESS] Release vX.Y.Z is now live!` and pause. Press any key to close the window.

The EMR auto-update system and direct installer link will immediately point to the newly published files on GitHub!
