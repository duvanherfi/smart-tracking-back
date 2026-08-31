# Smart Tracking — API

[![codecov](https://codecov.io/gh/duvanherfi/smart-tracking-back/graph/badge.svg?token=IFGE0O53B5)](https://codecov.io/gh/duvanherfi/smart-tracking-back)

Rails 8 API for a fleet-tracking app: it sits in front of a third-party GPS
provider, keeps its own users, vehicles, positions and geofences in MongoDB, and
serves the [Flutter client](https://github.com/duvanherfi/smartTracking-flutter).
Final integrative project of the MSc in Intelligent Applications, Universidad
del Valle. The manuals live in
[smart-tracking-docs](https://github.com/duvanherfi/smart-tracking-docs).

## What it actually does

- **Wraps the GPS provider.** `GpsService` logs in once, caches the session and
  translates the provider's payloads into `Vehicle`, `Position` and
  `Notification` documents. Every upstream endpoint is stubbed in the specs, so
  the suite never touches the network.
- **Geofences three ways** (`GeoFence#type`): a circle from a centre and a
  radius, a free polygon drawn by the user, or a *recommended* one. Circles are
  turned into 64-step polygons with Turf, and every fence gets a centroid and a
  reverse-geocoded street label before it is saved.
- **Recommended geofences come from where the vehicle actually goes.**
  `Vehicle#recommended` takes this year's positions, maps each one onto Uber's
  **H3** hexagonal grid, deduplicates the cells and unions them back into a
  GeoJSON polygon. The places a vehicle keeps returning to fall out of the grid
  on their own — no clustering parameters to tune.
- **Token sessions.** `Session` mints a `SecureRandom.urlsafe_base64(40)` token
  per login and checks it for uniqueness; passwords are bcrypt.

## Stack

Ruby 3.3.8, Rails 8.0, MongoDB via Mongoid, Redis and Sidekiq for background
work, HTTParty for the upstream calls, `turf-ruby` for polygon geometry, `h3`
for the hexagonal grid. Deployed with Kamal from the committed `Dockerfile`.

## Running it

```bash
bundle install
cp .env.example .env      # then fill in the real values
bin/rails server
```

MongoDB and Redis have to be reachable at whatever `.env` says.

### What you cannot get from here

Two of those variables point at services that are not mine to hand out, so a
clone of this repository will not talk to a real fleet:

- **`GPS_SERVICE`, `GPS_USER`, `GPS_PASSWORD`** — an account with the
  commercial GPS provider this API sits in front of. `GpsService` logs in with
  a phone number and a numeric password and gets a bearer token back. There is
  no public sandbox; without an account, every endpoint that reaches upstream
  returns nothing.
- **`REVERSE_SERVICE`** — a reverse-geocoding service exposing
  `GET /api/v1/reverse?lat=&lon=`. Any geocoder will do if you wrap it in that
  shape; it is only used to put a street name on a geofence.

The deployment those pointed at is gone, and so is the domain.

**The test suite does not need either of them.** `spec/support/gps_service_faker.rb`
is a Sinatra app that replays the committed fixtures, and `rails_helper` points
WebMock at it, so `bundle exec rspec` is green against the values in
`.env.example`. One catch worth knowing: `GPS_SERVICE` has to start with
`http://`, not `https://` — `rails_helper` builds the stub pattern by stripping
`http://` only, and an `https://` value produces a pattern that never matches.

## Tests

```bash
bundle exec rspec
```

52 examples, all green, with the upstream provider replaced by a Sinatra fake
(`spec/support/gps_service_faker.rb`) that replays the JSON fixtures.

**The fixtures carry no real data.** They started life as captured responses;
before this repo was made public every trace was moved to a different place on
Earth by a constant offset — distances, clusters and geofence geometry are
unchanged, the location is not — and the token, phone numbers, email and plate
were replaced with obvious placeholders. `GPS_SERVICE` points at a fake host in
the test run, so nothing leaves the machine.

## Note on scope

This was a team project with SCRUM roles; the code in this repository is the
part written by [@duvanherfi](https://github.com/duvanherfi), which is what the
commit history shows.
