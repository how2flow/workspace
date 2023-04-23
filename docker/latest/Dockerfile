# Dockerfile

# ===== No Edit =====
FROM how2flow/workspace:base
# ===================

ENV ID="user"

# ===== No Edit =====
USER root
WORKDIR /root
COPY fixups fixups
RUN chmod -R +x fixups
# ===================

# ===== No Edit =====
WORKDIR /root/fixups
RUN ./postfix $ID
# ===================
# TODO ...
RUN ./pkg
# ===== No Edit =====
RUN rm -rf fixups
# ===================

# ===== No Edit =====
USER ${ID}
WORKDIR /home/${ID}
# ===================
# TODO ...
RUN vim +PluginInstall +qall
