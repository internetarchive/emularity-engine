FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN rm -f index.html && \
    ln -sf /usr/share/nginx/html/default.conf /etc/nginx/conf.d/default.conf


# COPY . .
# logically is what we do next.
# split out this way because *one* 5GB single layer is brutal and any network hiccup starts over
#
# we show counts of filenames for each pattern, based on looking at
#   ls |cut -b5 |sort |uniq -c
# and finding 5th char had the most normal distribution
# We group some rarer chars together near the end

# chexxx w/ local build rsync -Pav --dry-run w/ clone both way, etc.
COPY gof sae ./ # copy short filename and short dirname first

COPY ????[aA]* .   # 524
COPY ????[bB]* .   # 266
COPY ????[cC]* .   # 346
COPY ????[dD]* .   # 294
COPY ????[eE]* .   # 381
COPY ????[fF]* .   # 167
COPY ????[gG]* .   # 262
COPY ????[hH]* .   # 207
COPY ????[iI]* .   # 317
COPY ????[jJ]* .   # 164
COPY ????[kK]* .   # 202
COPY ????[lL]* .   # 298 - NOTE: picks up ruffle subdir here
COPY ????[mM]* .   # 387
COPY ????[nN]* .   # 343
COPY ????[oO]* .   # 378
COPY ????[pP]* .   # 282

COPY ????[rR]* .   # 398
COPY ????[sS]* .   # 529
COPY ????[tT]* .   # 459
COPY ????[uU]* .   # 188

COPY ????[qQvVwWxXyYzZ]* . # 402

COPY ????[0-9]* .     # 476
COPY ????[-._]* .     # 233
