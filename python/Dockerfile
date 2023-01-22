FROM python

COPY --from=nvim:latest /usr/local/share/nvim /usr/local/share/nvim
COPY --from=nvim:latest /usr/local/bin /usr/local/bin
COPY --from=nvim:latest /root/.config /root/.config
COPY --from=nvim:latest /root/.local/share /root/.local/share

RUN touch /.nvim-python

RUN pip install \
  python-lsp-server \
  mypy \
  black \
  reorder-python-imports

