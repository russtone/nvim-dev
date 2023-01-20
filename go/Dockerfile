FROM golang

COPY --from=nvim:latest /usr/local/share/nvim /usr/local/share/nvim
COPY --from=nvim:latest /usr/local/bin /usr/local/bin
COPY --from=nvim:latest /root/.config /root/.config
COPY --from=nvim:latest /root/.local/share /root/.local/share

RUN go install golang.org/x/tools/gopls@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/incu6us/goimports-reviser/v3@latest

