#!/bin/bash

docker_flag=false
gem5_path=""
image=""
programa=""
tipo_preditor=""

function usage {
    echo "Usage: 
$0 [-d|--docker] [-i|--image <image>] -g|--gem5 <gem5-path> [-p|--path <programa>]"
    exit 1
}

# Process command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -d | --docker)  docker_flag=true;;
        -i | --image)   shift; image="$1";;
        -g | --gem5)    shift; gem5_path="$1";;
        -p | --path)    shift; programa="$1";;
        *)
            usage
    esac
    shift
done

# Check if gem5 path is provided
if [ -z "$gem5_path" ]; then
    gem5_path="$HOME/gem5"
fi

if [ -z "$programa" ]; then
    echo "INFO: Compilando programa:"
    gcc -o ./assembly/syrk.out -no-pie ./assembly/syrk.s
    programa="./assembly/syrk.out"
fi
if [ ! -d "$gem5_path/tests/test-progs/syrk" ]; then
    mkdir "$gem5_path/tests/test-progs/syrk"
fi

# Execute gem5 with provided path
if [ "$docker_flag" = true ]; then
    if [ -z "$image" ]; then
        echo "ERRO: Imagem Docker não fornecida."
        exit 1
    fi

    echo "INFO: Movendo programa para o gem5:"
    cp "$programa" "$gem5_path/tests/test-progs/syrk/syrk.out"

    echo "INFO: Abrindo imagem Docker: $image"
    # docker build Dockerfile -t "syrk-gem5"
    read -p "qual preditor de branch deseja usar? ('LocalBP', 'BiModeBP'): " tipo_preditor
    docker run -v "$gem5_path:/gem5" -it $image /bin/bash -c "cd /gem5; ./build/X86/gem5.opt configs/deprecated/example/se.py --cmd=tests/test-progs/syrk/syrk.out --cpu-type=O3CPU --bp-type=$tipo_preditor --caches"
else
    cd "$gem5_path/gem5"
    run_gem5
fi

function run_gem5 {
    ./build/X86/gem5.opt configs/deprecated/example/se.py --cmd=tests/test-progs/syrk/syrk.out --cpu-type=O3CPU --bp-type=$tipo_preditor --caches
}
