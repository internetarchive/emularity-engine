# syntax=docker/dockerfile:1.7-labs
# ^ need that first line comment for COPY --parents 2024 goodness

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN rm -f index.html && \
    ln -sf /usr/share/nginx/html/default.conf /etc/nginx/conf.d/default.conf

# split COPY . . into many layers so a single file change only re-pulls one small layer.
# (one 5GB layer is brutal — any network hiccup on docker pull restarts from zero)
#
# COPY --parents preserves directory structure so subdir/file never clobbers top-level file.
# layers are content-hashed so unchanged buckets are skipped on docker pull.
#
# pattern based on 5th char having the most uniform distribution:
#   ls |cut -b5 |sort |uniq -c
#
# counts (approximate, from original analysis):
#   [aA]=524 [bB]=266 [cC]=346 [dD]=294 [eE]=381 [fF]=167
#   [gG]=262 [hH]=207 [iI]=317 [jJ]=164 [kK]=202 [lL]=298
#   [mM]=387 [nN]=343 [oO]=378 [pP]=282 [rR]=398 [sS]=529
#   [tT]=459 [uU]=188 [qQvVwWxXyYzZ]=402 [0-9]=476
#   short (1-4 char names/dirs) + non-alphanumeric 5th char = safety net

COPY --parents ????[aA]* .
COPY --parents ????[bB]* .
COPY --parents ????[cC]* .
COPY --parents ????[dD]* .
COPY --parents ????[eE]* .
COPY --parents ????[fF]* .
COPY --parents ????[gG]* .
COPY --parents ????[hH]* .
COPY --parents ????[iI]* .
COPY --parents ????[jJ]* .
COPY --parents ????[kK]* .
COPY --parents ????[lL]* .
COPY --parents ????[mM]* .
COPY --parents ????[nN]* .
COPY --parents ????[oO]* .
COPY --parents ????[pP]* .
# skip qQ until later
COPY --parents ????[rR]* .
COPY --parents ????[sS]* .
COPY --parents ????[tT]* .
COPY --parents ????[uU]* .
# round up together a bunch of unpopular chars
COPY --parents ????[qQvVwWxXyYzZ]* .
# all digits together
COPY --parents ????[0-9]* .
# safety net: short names/dirs and any non-alphanumeric 5th char (eg: - _ . *)
COPY --parents ?[^/] ??[^/] ???[^/] ????[^/] ?/ ??/ ???/ ????/ ????[^a-zA-Z0-9]* .
