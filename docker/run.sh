sudo docker run -v /usr/lib/x86_64-linux-gnu/libnvoptix.so.1:/usr/lib64/libnvoptix.so.1 \
   -v /usr/lib/x86_64-linux-gnu/libnvoptix.so.418.56:/usr/lib64/libnvoptix.so.418.56 \
   -v /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so.418.56:/usr/lib64/libnvidia-rtcore.so.418.56 \
   -v $(pwd)/notebooks:/app/mitsuba2/notebooks  --rm --gpus all -p 8888:8888  -it mitsuba_jupyter
