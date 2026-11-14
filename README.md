# Pi Pocket on Railway

Pi Pocket — a durable, multiplayer, mobile-first web app for Pi coding agents. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

Upstream: [TannerMidd/pi-pocket](https://github.com/TannerMidd/pi-pocket) (MIT), release v0.29.0-beta.8 (`cbb1eba`), built from upstream's own `docker/Dockerfile`, app unmodified. Image: `ghcr.io/onepush-dev/pi-pocket:0.29.0-beta.8`.

## What the template sets up

- One service `pi-pocket` on port 8080 with a public HTTPS domain, healthcheck `/style.css`.
- One volume at `/data`: Pi Pocket's database and settings, plus `pi/` (Pi's `~/.pi`: provider sign-ins, skills, sessions), `workspace/` (projects Pi works on), `extensions/` and `themes/`.
- `PI_POCKET_OWNER_TOKEN` is generated per deploy and pre-seeded as the owner's sign-in token on first boot.

## Sign in

Open `https://<your-domain>/login?token=<PI_POCKET_OWNER_TOKEN>` once per browser (copy the token from the service's Variables tab). The token is also printed in the deploy logs on every start (those log links show the container's address; keep the path and token, swap in your Railway domain). Keep the link private: it is the owner key. Other devices: Menu → "Sign in another device".

Then sign in to a model provider from the app's Providers sheet, or add `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` as service variables (optional, bring your own).

## Notes

- Anyone who can steer a session can make Pi run commands inside this container (as root, with access to the volume and any provider keys). Invite only people you trust; view-only users cannot make Pi act. See upstream SECURITY.md.
- Chromium runs with `--no-sandbox` (needed in a container) for the Browser panel. Give the service at least 1–2 GB RAM.
- Changing `PI_POCKET_OWNER_TOKEN` after the first boot does nothing; rotate the token in the app instead.
- In-app "Update Pi Pocket" does not apply to the image; redeploy a newer image tag.
