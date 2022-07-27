FROM python:3.8

LABEL NAME="python-3.8" \
      VERSION="3.8" \
      DESC="Python3.8 container"
# Set the http(s) proxy server
ENV http_proxy http://host.docker.internal:3128
ENV https_proxy http://host.docker.internal:3128

# Set the working directory inside the Docker image
WORKDIR /workspace

# Copy everything except for files listed in .dockerignore
COPY . /workspace

# Install dependencies
RUN pip install -r requirements.txt

# Install the app
RUN pip install -e .
