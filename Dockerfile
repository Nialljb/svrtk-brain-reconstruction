# Use the latest Python 3 docker image
FROM nialljb/fw-svrtk-base as base

ENV HOME=/root/
ENV FLYWHEEL="/flywheel/v0"
ENV TOOLS="/home/"
WORKDIR $FLYWHEEL
RUN mkdir -p $FLYWHEEL/input

# Installing the current project (most likely to change, above layer can be cached)
COPY ./ $FLYWHEEL/

# Dev dependencies (conda, jq, poetry, flywheel installed in base)
RUN apt-get update && \
    apt-get clean && \
    pip install flywheel-gear-toolkit && \
    pip install flywheel-sdk && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installing main dependencies
# FSL (add additional dep here)
# SVRTK developed in home directory, so need to source this as working in /flywheel/v0
# set SVRTKDIR so SVRTK tools can use it, in this minimal case, the SVRTKDIR will be the root/home/ directory
ENV PATH="/home:${PATH}"
# ENV FSLDIR="/opt/conda"

# Configure entrypoint
RUN bash -c 'chmod +rx $FLYWHEEL/run.py' && \
    bash -c 'chmod +rx $FLYWHEEL/app/'
ENTRYPOINT ["python3","/flywheel/v0/run.py"] 
# Flywheel reads the config command over this entrypoint