# Clear the Air — Contact Your LA Councilmember

A single-page, zero-backend civic tool that helps Los Angeles residents demand
transparency about air quality during the **Boyle Heights warehouse fire** (the
Lineage Logistics cold-storage facility fire).

A user enters their address, the page finds their **LA City Council district** and
**councilmember**, and generates a professional, sternly written letter — pre-signed
with the user's name — that they can edit and send to their representative (and
optionally CC Mayor Karen Bass) in one click via Gmail, their default mail app, or
copy/paste.

## Use it

Open `index.html` in any browser. That's the whole app — one self-contained file,
no build step, no server, no API keys. Host it anywhere static (GitHub Pages,
Netlify, S3, or just send the file).

## How it works

1. **Geocode** — the address is converted to a map coordinate by the public
   Esri/ArcGIS World geocoder (no key, token-free single-line geocoding).
2. **District lookup** — that coordinate is matched against the City of Los Angeles
   official **Council District boundaries** (LA GeoHub `Boundaries` MapServer,
   layer 13) via a point-in-polygon spatial query.
3. **Letter** — the district's councilmember is paired with their public email and a
   pre-written, editable letter signed with the user's name and address.

Both map calls use **JSONP**, so the tool works as a pure static page with no CORS
proxy or backend.

### Privacy

Nothing the user types is stored or sent to any server we control. The address is
sent only to the anonymous public mapping services above to resolve the district.

## Data & accuracy

- **Districts & current councilmembers** are read live from the LA GeoHub service,
  so the displayed name stays current even if a seat changes hands.
- **Contact emails** are kept in a small table in `index.html` (`DISTRICTS`). They
  follow the official `councilmember.<name>@lacity.org` format. The UI always links
  to the official `cd<N>.lacity.gov` site and prompts users to verify before sending.
- Boyle Heights is **Council District 14 — Councilmember Ysabel Jurado**
  (`councilmember.jurado@lacity.org`).

To update a contact, edit the `DISTRICTS` object near the top of the `<script>` in
`index.html`.

## Sources

- Boundaries & councilmembers: [LA GeoHub](https://geohub.lacity.org/)
- Contacts: [lacity.gov elected officials](https://lacity.gov/government/elected-officials)
- Fire & air-quality reporting: ABC7, LAist, KTLA, NBC LA

## Disclaimer

Independent, nonpartisan civic tool with no affiliation to the City of Los Angeles.
Contact details are public information; verify the email on the official council
website before sending. For active emergencies, follow official guidance and call 911.
