# Bash-Project
# File Cleanup Utility

This script helps to clean up files in a specified directory based on their age or file extension. You can choose to either archive the targeted files or delete them entirely.

## Features
- Delete files older than a certain number of days
- Target files with a specific file extension
- Archive files into a compressed `.tar.gz` file instead of deleting them
- Interacts with files to either delete or archive
- Handles invalid arguments and provides helpful error messages

## Usage

```bash
./file_cleanup.sh [options] directory

