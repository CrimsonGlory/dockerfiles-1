#!/bin/bash

exec liquidsoap - <<-LIQ
set("init.daemon", false)
set("log.stdout", true)
set("log.file", false)
set("log.file.path","/var/log/liquidsoap/${LOG_NAME}")
set("harbor.bind_addr", "0.0.0.0")

live = input.harbor("$LIVE_ENDPOINT", port=$LIVE_PORT, password="$LIVE_PASSWORD")
files = playlist.safe("$PLAYLIST_DIR", reload=300, reload_mode="seconds")
radio = fallback(track_sensitive=false, [ live, files ])

output.icecast(
  %mp3.cbr(bitrate=128, samplerate=48000, stereo=true),
  mount="/stream.mp3",
  name="${STREAM_NAME} [MP3]",
  url="${STREAM_URL}",
  genre="${STREAM_GENRE}",
  host="${ICECAST_HOSTNAME}",
  port=${ICECAST_PORT},
  password="${ICECAST_PASS}",
  radio
)

output.icecast(
  %vorbis.cbr(bitrate=96, samplerate=48000, channels=2),
  mount="/stream.ogg",
  name="${STREAM_NAME} [OGG]",
  url="${STREAM_URL}",
  genre="${STREAM_GENRE}",
  host="${ICECAST_HOSTNAME}",
  port=${ICECAST_PORT},
  password="${ICECAST_PASS}",
  radio
)

output.icecast(
  %opus(bitrate=64, samplerate=48000, channels=2),
  mount="/stream.opus",
  name="${STREAM_NAME} [Opus]",
  url="${STREAM_URL}",
  genre="${STREAM_GENRE}",
  host="${ICECAST_HOSTNAME}",
  port=${ICECAST_PORT},
  password="${ICECAST_PASS}",
  radio
)
LIQ
