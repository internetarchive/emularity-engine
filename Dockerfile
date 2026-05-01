# copy all our files into a multi-stage build we can COPY from and then throw out:
FROM nginx:alpine AS src
COPY . /src/

# now start the real image setup
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN rm -f index.html && \
    ln -sf /usr/share/nginx/html/default.conf /etc/nginx/conf.d/default.conf &&\
    apk add --no-cache rsync

# split COPY . . into many layers so a single file change only re-pulls one small layer.
# (one 5GB layer is brutal — any network hiccup on docker pull restarts from zero)
#
# uses rsync via --mount=type=bind from throwaway stage 1 (never pushed to registry).
# shell globs are used (not Go filepath.Match) so special chars like - and * just work.
# subdirs are preserved naturally by rsync -a, no special-casing needed.
#
# pattern based on 5th char having the most uniform distribution:
#   ls |cut -b5 |sort |uniq -c
#
# counts (approximate, from original analysis):
#   [aA]=524 [bB]=266 [cC]=346 [dD]=294 [eE]=381 [fF]=167
#   [gG]=262 [hH]=207 [iI]=317 [jJ]=164 [kK]=202 [lL]=298
#   [mM]=387 [nN]=343 [oO]=378 [pP]=282 [rR]=398 [sS]=529
#   [tT]=459 [uU]=188 [qQvVwWxXyYzZ]=402 [0-9]=476 [._-]=233
#   short (1-4 char names/dirs) = safety net catchall

RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[aA]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[bB]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[cC]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[dD]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[eE]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[fF]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[gG]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[hH]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[iI]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[jJ]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[kK]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[lL]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[mM]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[nN]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[oO]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[pP]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[rR]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[sS]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[tT]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[uU]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[qQvVwWxXyYzZ]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[0-9]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/????[*._-]* ./
RUN --mount=type=bind,from=src,source=/src,target=/mnt rsync -a /mnt/???? /mnt/??? /mnt/?? /mnt/? ./ \
  2>/dev/null || true
