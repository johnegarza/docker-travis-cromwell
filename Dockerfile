FROM ubuntu:xenial
MAINTAINER John Garza <johnegarza@wustl.edu>
LABEL \
    description="Image used by Travis CI to test Cromwell workflows"

RUN apt-get update -y && apt-get install -y \
    default-jdk \
    python \
    python-pip \
    wget

RUN pip install --upgrade pip
RUN pip install 'setuptools>=18.5'
RUN pip install cwltool
RUN pip install 'ruamel.yaml==0.14.2'

RUN wget https://github.com/broadinstitute/cromwell/releases/download/34/cromwell-34.jar

ENTRYPOINT ["java", "-jar", "cromwell-34.jar", "run", "-t", "cwl", "-i", "./cancer-genomics-workflow/example_data/exome_workflow.yaml", "./cancer-genomics-workflow/exome_workflow.cwl"]
