#!/usr/bin/env bash 

IMAGE=flywheel/svrtk-brain-reconstruction:0.1.1

# Command:
docker run -it --rm --entrypoint bash\
	-v /Users/nbourke/GD/atom/unity/fw-gears/fw-svrtk/svrtk-brain-reconstruction-0.1.1-64d65814a9c8eea18d857e70/input:/flywheel/v0/input\
	-v /Users/nbourke/GD/atom/unity/fw-gears/fw-svrtk/svrtk-brain-reconstruction-0.1.1-64d65814a9c8eea18d857e70/output:/flywheel/v0/output\
	-v /Users/nbourke/GD/atom/unity/fw-gears/fw-svrtk/svrtk-brain-reconstruction-0.1.1-64d65814a9c8eea18d857e70/work:/flywheel/v0/work\
	-v /Users/nbourke/GD/atom/unity/fw-gears/fw-svrtk/svrtk-brain-reconstruction-0.1.1-64d65814a9c8eea18d857e70/config.json:/flywheel/v0/config.json\
	-v /Users/nbourke/GD/atom/unity/fw-gears/fw-svrtk/svrtk-brain-reconstruction-0.1.1-64d65814a9c8eea18d857e70/manifest.json:/flywheel/v0/manifest.json\
	$IMAGE
