#!/bin/bash

# Function to display the help message
show_help() {
    echo "Usage: $0 [options] directory"
    echo "Options:"
    echo "  -h            Display this help message"
    echo "  -d DAYS       Delete files older than DAYS"
    echo "  -e EXT        Target files with specific file extension (e.g., .log)"
    echo "  -a            Archive files instead of deleting them"
    echo "  -r            Remove the targeted files"
    echo "  Example: $0 -d 7 -e log -a /path/to/directory"
    exit 0
}

# Error if no arguments are provided
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided. Use -h for help."
    exit 1
fi

# Initialize variables
days=""
extension=""
archive=false
remove=false

# Parse options
while getopts ":hd:e:ar" opt; do
    case ${opt} in
        h )
            show_help
            ;;
        d )
            days=$OPTARG
            ;;
        e )
            extension=$OPTARG
            ;;
        a )
            archive=true
            ;;
        r )
            remove=true
            ;;
        \? )
            echo "Invalid option: -$OPTARG. Use -h for help." >&2
            exit 1
            ;;
        : )
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check if directory is provided
if [[ -z "$1" ]]; then
    echo "Error: Directory not specified. Use -h for help."
    exit 1
fi

directory=$1

# Check if the directory exists
if [[ ! -d "$directory" ]]; then
    echo "Error: Directory $directory does not exist."
    exit 1
fi

# Build the find command based on user input
find_cmd="find $directory"

if [[ ! -z "$days" ]]; then
    find_cmd+=" -type f -mtime +$days"
fi

if [[ ! -z "$extension" ]]; then
    find_cmd+=" -name '*.$extension'"
fi

# List the files to be cleaned up
echo "Files to be cleaned up:"
eval "$find_cmd"

# Check if archive option is selected
if $archive; then
    archive_name="backup_$(date +%Y%m%d%H%M%S).tar.gz"
    echo "Archiving files to $archive_name"
    eval "$find_cmd" | tar -czvf "$archive_name" -T -
fi

# Check if remove option is selected
if $remove; then
    echo "Removing files..."
    eval "$find_cmd" -delete
fi

# Final message
if ! $archive && ! $remove; then
    echo "No action taken. Use -a to archive or -r to remove the files."
fi

exit 0
