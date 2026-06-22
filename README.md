# Clear the Air — Contact Your LA Councilmember

A single-page, zero-backend civic tool that helps Los Angeles residents demand
transparency about air quality during the **Boyle Heights warehouse fire** (the
Lineage Logistics cold-storage facility fire).

A user enters their address; the page finds their **LA City Council district** and
**councilmember**, then generates a professional, sternly written letter — pre-signed
with the user's name — that they can edit and send in one click via Gmail, their
default mail app, or copy/paste. If they'd rather call, every result also shows
click-to-call phone numbers.

Source: <https://github.com/imgmatt/la-aqi-contact>

## What it does

- **Header + intro** framing the Boyle Heights fire and the ask.
- **Address → district → councilmember** lookup (no account, no address stored).
- **Generated letter** that is stern, professional, and demands transparent
  air-quality data, monitoring, health guidance, and accountability. It references
  the symptoms residents across East and Central LA have reported (shortness of
  breath, headaches, burning skin, fatigue) and is signed with the user's name,
  district, and address.
- **Anti-spam wording variation** — every letter is assembled from interchangeable
  phrasings (varied openers/synonyms, shuffled demand order, rotating subject and
  sign-off) so no two senders submit a byte-identical message. The facts and the
  four demands never change, only the phrasing.
- **"Preview a sample letter"** button shows the full letter (addressed to CD14 /
  Boyle Heights as an example) without requiring any address.
- **Send options:** Open in Gmail (mobile-aware — see below), open in default mail
  app (`mailto:`), copy the letter, or copy the councilmember's email address.
- **Click-to-call phone numbers** — a verified district/field office line where
  available, plus the City Hall line, as `tel:` links.
- **Live air-quality link** to the [IQAir LA map](https://www.iqair.com/air-quality-map/usa/california/los-angeles).
- **No data collected** — everything stays in the browser (shown as a pill up top).

## Use it

Open `index.html` in any browser. That's the whole app — one self-contained file,
no build step, no server, no API keys. Host it anywhere static (GitHub Pages,
Netlify, S3, or just send the file).

## Deploy to Railway

The repo ships a `Dockerfile` + `Caddyfile` that serve the page with
[Caddy](https://caddyserver.com/) on Railway's injected `$PORT`. Two ways to ship it:

### Option A — from the Railway dashboard (no CLI)

1. Push this repo to GitHub (already at `imgmatt/la-aqi-contact`).
2. In Railway: **New Project → Deploy from GitHub repo** and pick it.
3. Railway detects the `Dockerfile` and builds automatically (config is pinned in
   `railway.json`). No environment variables are required.
4. Open the service → **Settings → Networking → Generate Domain** to get a public URL.

### Option B — from the Railway CLI

```bash
npm i -g @railway/cli      # install the CLI
railway login              # opens the browser to authenticate
railway init               # create a new project (run from this folder)
railway up                 # build & deploy the Dockerfile
railway domain             # generate a public URL
```

Either way, the running container serves `index.html` on `$PORT` with gzip/zstd
compression and sensible security headers. To use a custom domain, add it under the
service's **Settings → Networking → Custom Domain** and point your DNS CNAME at the
Railway target.

## How it works

1. **Geocode** — the address is converted to a map coordinate by the public
   Esri/ArcGIS World geocoder (no key, token-free single-line geocoding).
2. **District lookup** — that coordinate is matched against the City of Los Angeles
   official **Council District boundaries** (LA GeoHub `Boundaries` MapServer,
   layer 13) via a point-in-polygon spatial query.
3. **Letter** — the district's councilmember is paired with their public contact info
   and the generated, editable letter.

Both map calls use **JSONP**, so the tool works as a pure static page with no CORS
proxy or backend.

### "Open in Gmail" on mobile

The button prefills the recipient, subject, and body in all cases, but takes a
platform-specific path so it actually opens a compose window:

- **iOS** — deep-links into the Gmail app (`googlegmail:///co?...`); if the app
  isn't installed, a timed fallback opens Gmail web compose.
- **Android** — fires an Android intent targeting `com.google.android.gm` with a
  `mailto:` payload, plus a `browser_fallback_url` to web compose if Gmail isn't
  installed.
- **Desktop** — opens Gmail web compose in a new tab.

### Privacy

Nothing the user types is stored or sent to any server the project controls. The
address is sent only to the anonymous public mapping services above to resolve the
district.

## Data & accuracy

- **Districts & current councilmembers** are read live from the LA GeoHub service,
  so the displayed name stays current even if a seat changes hands.
- **Contact emails** are kept in a small table in `index.html` (`DISTRICTS`). They
  follow the official `councilmember.<name>@lacity.org` format. The UI always links
  to the official `cd<N>.lacity.gov` site and prompts users to verify before sending.
- Boyle Heights is **Council District 14 — Councilmember Ysabel Jurado**
  (`councilmember.jurado@lacity.org`).
- **Phone numbers:** where a district/field office number was verified from the
  official `cdN.lacity.gov` site (CD1, 2, 3, 9, 13, 14) it is shown as the primary
  **District office** line. Every office also shares the **City Hall line
  (213) 473-70NN** (CD1 = 7001 … CD14 = 7014), derived from the district number,
  shown as a reliable fallback for all 15. Districts without a cleanly verifiable
  single office number (multiple field offices, or none listed) show City Hall only.

To update a contact, edit the `DISTRICTS` object near the top of the `<script>` in
`index.html` (each entry takes `name`, `email`, and an optional `office` phone).

## Sources

- Boundaries & councilmembers: [LA GeoHub](https://geohub.lacity.org/)
- Emails & office phones: official `cdN.lacity.gov` council district sites and
  [lacity.gov elected officials](https://lacity.gov/government/elected-officials)
- Fire & air-quality reporting: ABC7, LAist, KTLA, NBC LA

## Disclaimer

Independent, nonpartisan civic tool with no affiliation to the City of Los Angeles.
Contact details are public information; verify the email on the official council
website before sending. For active emergencies, follow official guidance and call 911.
