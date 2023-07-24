# Dockerfile

# Dockerfile with how2flow/config:{tag}

# ===== No Edit =====
FROM how2flow/config:jammy
# ===================

# ===== Edit you want =====
ENV ID="jekyll" \
  PASSWORD="jekyll"
# =========================

# ===== No Edit =====
USER root
RUN /postfix.sh $ID $PASSWORD
# ===================

# TODO with root permission ...
ADD fixups /
RUN chmod +x /pkg
RUN /pkg && rm -rf /pkg

# ===== No Edit =====
RUN rm -f /*.sh
# ===================

# ===== No Edit =====
USER ${ID}
WORKDIR /home/${ID}
RUN vim +PluginInstall +qall
# ===================

# TODO with normal permission in /home/${ID} ...

