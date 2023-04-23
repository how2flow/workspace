# Dockerfile
FROM how2flow/workspace:base

ENV ID="user"

USER root
WORKDIR /root
COPY fixups fixups
RUN chmod -R +x fixups
RUN ./fixups/pkg
RUN ./fixups/chid $ID
# RUN ./fixups/..
RUN rm -rf fixups

USER ${ID}
WORKDIR /home/${ID}
# user fixups ...
