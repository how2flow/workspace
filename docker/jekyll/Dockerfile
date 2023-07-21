# Dockerfile

# Dockerfile with how2flow/config:{tag}

# ===== No Edit =====
FROM how2flow/config:jammy
# ===================

# ===== Edit you want =====
ENV ID="jekyll"
  PASSWORD="jekyll"
# =========================

# ===== No Edit =====
USER root
WORKDIR /root
COPY fixups fixups
RUN chmod -R +x fixups
RUN ./fixups/postfix $ID $PASSWORD
# ===================

# TODO in /root ...
RUN ./fixups/pkg

# ===== No Edit =====
RUN rm -rf fixups
# ===================

# ===== No Edit =====
USER ${ID}
WORKDIR /home/${ID}
RUN vim +PluginInstall +qall
# ===================

# TODO in /home/${ID} ...

