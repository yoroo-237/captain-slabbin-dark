# Captain Slabbin - miroir onion (Tor)

Conteneur Railway : Tor + nginx. nginx relaie vers le site clearnet existant (`UPSTREAM_HOST`).
Le projet clearnet n'est ni modifie ni redeploye : seul ce nouveau service est cree.

## Deploiement Railway

1. Pousser ce dossier dans son propre depot git (jamais dans le depot du site existant).
2. Railway > New Project > Deploy from GitHub repo (Dockerfile detecte).
3. Variables : `UPSTREAM_HOST` = domaine clearnet, sans https:// (ex: `captainslabbin.com`).
4. Volume : le monter sur `/var/lib/tor` (conserve la cle privee => l'adresse .onion ne change pas).
5. Settings : Replicas = 1, Restart policy = Always. Ne pas generer de domaine public.
6. Les logs affichent `=== ADRESSE ONION : xxxx.onion ===`.
7. Sauvegarder `hs_ed25519_secret_key` (dans `/var/lib/tor/hs/`) hors de Railway.

## Surveillance

`monitor.sh` depuis une autre machine avec Tor, via cron.

## Limites connues

- Les liens absolus vers le domaine clearnet dans les pages restent tels quels (ils sortent de Tor).
- Les ressources externes (CDN, polices, analytics) du site ne passent pas par l'onion.
- Si le site clearnet tombe, l'onion tombe aussi.
