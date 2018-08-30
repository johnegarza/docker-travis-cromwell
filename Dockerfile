FROM ubuntu:xenial
MAINTAINER John Garza <johnegarza@wustl.edu>
LABEL \
    description="Image used by Travis CI to test Cromwell workflows"

RUN apt-get update -y && apt-get install -y \
    default-jdk \
    python \
    python-pip \
    wget

#set up cwltool
RUN pip install --upgrade pip
RUN pip install 'setuptools>=18.5'
RUN pip install cwltool
RUN pip install 'ruamel.yaml==0.14.2'

#download cromwell
RUN wget https://github.com/broadinstitute/cromwell/releases/download/34/cromwell-34.jar

#install docker, instructions from https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get update

RUN apt-get install -y docker-ce

#for ease of use, added an entrypoint so that travis can use this image as an executable
ENTRYPOINT ["java", "-Dconfig.file=cancer-genomics-workflow/travis.config", "-jar", "cromwell-34.jar", "run", "-t", "cwl", "-i", "cancer-genomics-workflow/example_data/exome_workflow.yaml", "cancer-genomics-workflow/exome_workflow.cwl"]
