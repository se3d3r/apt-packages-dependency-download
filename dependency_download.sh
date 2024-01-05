#!/bin/bash

# Define the packages to download
# ENTER YOUR PACKAGES HERE
packages=(
    PACKAGE_NAME_HERE1
    PACKAGE_NAME_HERE2
)

echo "downloading all dependencies.."

directory="./download"
if [ -d "$directory" ]; then
    # Directory exists, delete it
    sudo rm -r "$directory"
fi

# create new directory
mkdir -p "$directory"
echo "Directory created: $directory"
cd ./"$directory"

download_package_and_dependencies() {
    package=$1
    echo "Processing package: $package"

    apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests \
  --no-conflicts --no-breaks --no-replaces --no-enhances \
  --no-pre-depends ${package} | grep "^\w")


    if [ $? -ne 0 ]; then
        echo "Failed to download package: $package"
        exit 1
    fi

}

for package in "${packages[@]}"; do
    download_package_and_dependencies "$package"
    if [ $? -ne 0 ]; then
        echo "An error occurred while processing $package"
        xit 1
    fi
done

echo "All packages successfully downloaded"
