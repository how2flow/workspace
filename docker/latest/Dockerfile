# Dockerfile

# Dockerfile with how2flow/config:{tag}

# ===== No Edit =====
FROM how2flow/config:jammy
# ===================

# ===== Edit you want =====
ENV ID="user"
  PASSWORD="docker"
# =========================

# ===== No Edit =====
USER root
RUN /postfix.sh $ID $PASSWORD
# ===================

# TODO with root permission ...
ADD fixups /
RUN /fixups/pkg
RUN rm -rf fixups

# ===== No Edit =====
RUN rm -f /*.sh
# ===================

# ===== No Edit =====
USER ${ID}
WORKDIR /home/${ID}
RUN vim +PluginInstall +qall
# ===================

# TODO with normal permission in /home/${ID} ...

