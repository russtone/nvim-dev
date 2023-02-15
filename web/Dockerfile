FROM node

COPY --from=nvim:latest /usr/local/share/nvim /usr/local/share/nvim
COPY --from=nvim:latest /usr/local/bin /usr/local/bin
COPY --from=nvim:latest /root/.config /root/.config
COPY --from=nvim:latest /root/.local/share /root/.local/share

RUN apt-get update && apt-get install -y \
  zsh \
  locales \
  git \
  curl \
  file

# Set the locale
RUN sed -i "/en_US.UTF-8/s/^# //g" /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     
ENV TERM xterm-256color

# zsh
RUN ln -s /root/.config/zsh/zshenv /root/.zshenv && \
    ln -s /root/.config/zsh/zshrc /root/.zshrc

RUN touch /.nvim-web

RUN npm install -g \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted \
  @tailwindcss/language-server


ENTRYPOINT ["/usr/bin/zsh"]

# vim: ft=dockerfile
