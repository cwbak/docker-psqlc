FROM alpine:latest

RUN apk add --no-cache postgresql15-client=15.4-r0

ENTRYPOINT ["psql"]
