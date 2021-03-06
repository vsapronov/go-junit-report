#!/bin/bash -x

mkdir -p ./zips
mkdir -p ./dist

platforms=("windows/amd64" "darwin/amd64" "linux/amd64")
for platform in "${platforms[@]}"
do
    echo "Building platform: $platform"

    # parse platforms
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}

    ###### build and package spec
    output_name="go-junit-report_${GOOS}_${GOARCH}"

    exec_name="go-junit-report"
    if [ $GOOS = "windows" ]; then
        exec_name+='.exe'
    fi

    env GOOS=$GOOS GOARCH=$GOARCH go build -ldflags "-s -w" -o $exec_name go-junit-report.go
    if [ $? -ne 0 ]; then
        echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi

    mkdir -p ./dist/${GOOS}_${GOARCH}
    cp $exec_name ./dist/${GOOS}_${GOARCH}/$exec_name

    zip "./zips/$output_name.zip" $exec_name -q

    rm -rf ./output $exec_name "$output_name.zip"
done

echo "Done building version: $VERSION"
