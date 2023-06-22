#!/usr/bin/env bash


PYTHON_INSTALL_PATH="/usr/local/"
export PIPX_HOME="/usr/local/py-utils"
USERNAME=${1:-"vscode"}

DEFAULT_UTILS=("pylint" "flake8" "autopep8" "black" "yapf" "mypy" "pydocstyle" "pycodestyle" "bandit" "pipenv" "virtualenv")

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive


export PIPX_BIN_DIR="${PIPX_HOME}/bin"
export PATH="${PYTHON_INSTALL_PATH}/bin:${PIPX_BIN_DIR}:${PATH}"

# Create pipx group, dir, and set sticky bit
if ! cat /etc/group | grep -e "^pipx:" > /dev/null 2>&1; then
    groupadd -r pipx
fi
usermod -a -G pipx ${USERNAME}
umask 0002
mkdir -p ${PIPX_BIN_DIR}
chown :pipx ${PIPX_HOME} ${PIPX_BIN_DIR}
chmod g+s ${PIPX_HOME} ${PIPX_BIN_DIR}

# Update pip if not using os provided python
if [ ${PYTHON_VERSION} != "os-provided" ] && [ ${PYTHON_VERSION} != "system" ]; then
    echo "Updating pip..."
    ${PYTHON_INSTALL_PATH}/bin/python -m pip install --no-cache-dir --upgrade pip
fi

# Install tools
echo "Installing Python tools..."
export PYTHONUSERBASE=/tmp/pip-tmp
export PIP_CACHE_DIR=/tmp/pip-tmp/cache
pipx_path=""
if ! type pipx > /dev/null 2>&1; then
    pip3 install --disable-pip-version-check --no-cache-dir --user pipx 2>&1
    /tmp/pip-tmp/bin/pipx install --pip-args=--no-cache-dir pipx
    pipx_path="/tmp/pip-tmp/bin/"
fi
for util in ${DEFAULT_UTILS[@]}; do
    if ! type ${util} > /dev/null 2>&1; then
        ${pipx_path}pipx install --system-site-packages --pip-args '--no-cache-dir --force-reinstall' ${util}
    else
        echo "${util} already installed. Skipping."
    fi
done
rm -rf /tmp/pip-tmp

#export PIPX_HOME="${PIPX_HOME}"
#export PIPX_BIN_DIR="${PIPX_BIN_DIR}"
#if [[ "\${PATH}" != *"\${PIPX_BIN_DIR}"* ]]; then export PATH="\${PATH}:\${PIPX_BIN_DIR}"; fi
