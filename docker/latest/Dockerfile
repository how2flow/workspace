# Dockerfile
FROM how2flow/workspace:base

# vars
ENV ID="user"

# root fixups
USER root
WORKDIR /root
COPY fixups fixups
RUN chmod -R +x fixups
RUN ./fixups/pkg
RUN ./id $ID
RUN ./sudo $ID
RUN rm -rf fixups id sudo

# user fixups
USER ${ID}
WORKDIR /home/${ID}
