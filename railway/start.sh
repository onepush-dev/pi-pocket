#!/bin/sh
# Railway start wrapper for Pi Pocket: prepare the single volume, pre-seed the owner token once, then run upstream's entrypoint.
set -e
DATA="${PI_POCKET_DIR:-/data}"
mkdir -p "$DATA" "$DATA/pi" "$DATA/workspace" "$DATA/extensions" "$DATA/themes"
chmod 700 "$DATA"
if [ ! -f "$DATA/config.json" ] && [ -n "$PI_POCKET_OWNER_TOKEN" ]; then
  # Same shape Pi Pocket writes itself on first start (src/server/config.ts), with the token from the variable.
  node -e '
    const fs=require("fs"),c=require("crypto"),p=process.argv[1],t=process.env.PI_POCKET_OWNER_TOKEN;
    const cfg={version:1,ownerToken:t,users:[{id:c.randomUUID(),name:"Owner",role:"owner",
      tokenHash:c.createHash("sha256").update(t).digest("hex"),createdAt:Date.now()}]};
    fs.writeFileSync(p+".tmp",JSON.stringify(cfg,null,2)+"\n",{mode:0o600}); fs.renameSync(p+".tmp",p);
  ' "$DATA/config.json"
  echo "railway: owner sign-in token pre-seeded from PI_POCKET_OWNER_TOKEN"
fi
if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  echo "railway: open https://$RAILWAY_PUBLIC_DOMAIN/login?token=<token> once per browser (token = PI_POCKET_OWNER_TOKEN on first deploy; also printed below)"
fi
cd /workspace
exec /usr/local/bin/pi-pocket-entrypoint "$@"
