FROM golang:1.13-alpine3.10 AS builder
RUN  apk --update --no-cache add bash make ca-certificates 
WORKDIR /app
COPY . .
RUN make

FROM alpine:3.10
RUN  apk --update --no-cache add tzdata ca-certificates \
    && update-ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
WORKDIR /app
COPY --from=builder /app/coredns /usr/local/bin
COPY --from=builder /app/Corefile /app/Corefile
EXPOSE 53 53/udp
ENTRYPOINT [ "coredns" ]
CMD [ "-conf", "/app/Corefile" ]