#
# Builder
#

FROM debian

ARG neovim_branch=stable
ARG neovim_build_type=Release

# https://github.com/neovim/neovim/wiki/Building-Neovim
RUN apt-get update && apt-get install -y \
  git \
  ninja-build \
  gettext \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip \
  curl \
  doxygen

WORKDIR /usr/src

RUN git clone --depth 1 -b ${neovim_branch} https://github.com/neovim/neovim && \
  cd neovim && \
  make CMAKE_BUILD_TYPE=${neovim_build_type} -j4 && \
  make install

# Dotfiles
RUN git clone https://github.com/russtone/dotfiles /root/.config

# Install all plugins and tree sitter grammars
# Do it in builder because tree sitter grammars require compiler
RUN nvim --headless -c exit && \
    nvim --headless -c TSUpdate -c exit

#
# Base
#

FROM debian

ARG arch=arm64
ARG lf_version=r28

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

# Neovim
COPY --from=0 /usr/local/bin/nvim /usr/local/bin
COPY --from=0 /usr/local/share/nvim /usr/local/share/nvim
COPY --from=0 /usr/local/bin /usr/local/bin
COPY --from=0 /root/.config /root/.config
COPY --from=0 /root/.local/share /root/.local/share

WORKDIR /tmp

# lf
# TODO: remove when switch to telescope
RUN curl -LO https://github.com/gokcehan/lf/releases/download/${lf_version}/lf-linux-${arch}.tar.gz && \
    file lf-linux-${arch}.tar.gz && \
    tar xf lf-linux-${arch}.tar.gz && \
    mv lf /usr/local/bin && \
    rm lf-linux-${arch}.tar.gz

# starship
RUN curl -LO https://starship.rs/install.sh && sh install.sh -y

# zsh
RUN ln -s /root/.config/zsh/zshenv /root/.zshenv && \
    ln -s /root/.config/zsh/zshrc /root/.zshrc && \
    zsh -ic "whoami"

ENTRYPOINT ["/usr/bin/zsh"]
