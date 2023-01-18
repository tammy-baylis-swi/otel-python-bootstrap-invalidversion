#!/usr/bin/env sh

# stop on error
set -e

echo "Installing Python and pip..."
{
    if grep Ubuntu /etc/os-release; then
        ubuntu_version=$(grep VERSION_ID /etc/os-release | sed 's/VERSION_ID="//' | sed 's/"//')
        if [ "$ubuntu_version" = "18.04" ] || [ "$ubuntu_version" = "20.04" ]; then
            apt-get update -y
            TZ=America
            ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
            # get Python version from container hostname, e.g. "3.7", "3.10"
            python_version=$(grep -Eo 'py3.[0-9]+[0-9]*' /etc/hostname | grep -Eo '3.[0-9]+[0-9]*')
            if [ "$python_version" = "3.10" ] || [ "$python_version" = "3.11" ]; then
                # py3.10,3.11 not currently on main apt repo so use deadsnakes
                apt-get install -y software-properties-common
                add-apt-repository ppa:deadsnakes/ppa -y
            fi
            apt-get install -y \
                "python$python_version" \
                "python$python_version-distutils" \
                "python$python_version-dev" \
                build-essential \
                unzip \
                wget \
                curl
            update-alternatives --install /usr/bin/python python "/usr/bin/python$python_version" 1
            
            # Make sure we don't install py3.6's pip
            # Official get-pip documentation:
            # https://pip.pypa.io/en/stable/installation/#get-pip-py
            wget https://bootstrap.pypa.io/get-pip.py
            python get-pip.py
        fi
    fi

    pip install --upgrade pip >/dev/null
} >/dev/null

echo "Installing OTel and Flask"
pip install flask requests opentelemetry-api opentelemetry-sdk opentelemetry-instrumentation

if [ -z "$OLD_SETUPTOOLS" ]
then
    echo "Keeping latest setuptools"
else
    echo "Uninstalling latest setuptools and installing 65.7.0"
    apt-get remove python-setuptools
    pip install --ignore-installed setuptools==65.7.0
fi

echo "Bootstrapping OTel and running instrumented Flask"
opentelemetry-bootstrap --action=install
opentelemetry-instrument flask run
