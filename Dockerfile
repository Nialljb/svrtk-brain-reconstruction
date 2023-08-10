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
    pip3 install flywheel-gear-toolkit && \
    pip3 install flywheel_gear_toolkit && \
    pip3 install flywheel-sdk && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Configure entrypoint
RUN bash -c 'chmod +rx $FLYWHEEL/run.py' && \
    bash -c 'chmod +rx $FLYWHEEL/app/'
ENTRYPOINT ["python3","/flywheel/v0/run.py"] 
# Flywheel reads the config command over this entrypoint