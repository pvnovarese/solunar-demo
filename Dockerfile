ARG IMAGE=alpine
ARG OS=linux
ARG ARCH=amd64

FROM alpine:latest as builder

WORKDIR /solunar_cmdline
RUN apk update && apk add --no-cache git g++ make curl

# Clone private repository
RUN git clone https://github.com/kevinboone/solunar_cmdline.git /solunar_cmdline
RUN make clean && make

FROM alpine:latest
MAINTAINER Paul Novarese pvn@novarese.net
LABEL name="solunar-demo"
LABEL maintainer="pvn@novarese.net"

HEALTHCHECK --timeout=10s CMD /bin/date || exit 1
WORKDIR /usr/local/bin/
COPY --from=builder /solunar_cmdline/solunar solunar
RUN apk add -U tzdata bash && cp /usr/share/zoneinfo/America/Chicago /etc/localtime

CMD ["-c", "London"]
ENTRYPOINT ["/usr/local/bin/solunar"]
