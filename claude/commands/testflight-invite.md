---
description: Resend (or create) a TestFlight beta-tester invite via App Store Connect API
argument-hint: <tester-email> [app bundleId or name]
allowed-tools: Bash(node ~/.claude/scripts/asc-api.mjs:*)
---

Resend a TestFlight invite to a beta tester. Works for any of my apps.

Arguments: `$ARGUMENTS`
- First token = tester email (required).
- Rest (optional) = app bundle id (e.g. `no.laersmart.laeralbansk`) or a name
  substring to match. If omitted and only one app exists, use that. If multiple
  apps and no filter given, list them and ask which.

ASC API client: `node ~/.claude/scripts/asc-api.mjs <METHOD> '<path>' ['<json body>']`
(auth via ~/.appstoreconnect/private_keys + ~/.appstoreconnect/issuer_id).

Steps:
1. Resolve the app id:
   - bundle id given → `GET '/v1/apps?filter[bundleId]=<id>&fields[apps]=name,bundleId'`
   - name/substring → `GET '/v1/apps?fields[apps]=name,bundleId'`, match case-insensitive.
   - nothing given → `GET '/v1/apps?fields[apps]=name,bundleId'`; if one, use it; if many, list and stop for the user to pick.
2. Find the tester for that app, filtered by email:
   `GET '/v1/apps/<APPID>/betaTesters?filter[email]=<EMAIL>&fields[betaTesters]=email,state&include=betaGroups'`
   - If found, note tester id + current state.
   - If NOT found, the tester isn't added yet. Report it and ask whether to add
     them to a beta group first (list groups via
     `GET '/v1/apps/<APPID>/betaGroups?fields[betaGroups]=name,isInternalGroup'`),
     then add via `POST '/v1/betaTesters'` with the chosen group. Do not invent an email.
3. Resend the invite:
   `POST '/v1/betaTesterInvitations' '{"data":{"type":"betaTesterInvitations","relationships":{"app":{"data":{"type":"apps","id":"<APPID>"}},"betaTester":{"data":{"type":"betaTesters","id":"<TESTERID>"}}}}}'`
   - HTTP 201 = invite sent.
4. Report concisely: app name, tester email, prior state, result. Remind: tester
   must open the email → View in TestFlight → Accept; and the TestFlight app must
   be signed in with the Apple ID matching that exact email.

Notes:
- ACCOUNT_HOLDER/ADMIN role does NOT auto-grant TestFlight access — the Apple ID
  must still be an accepted beta tester.
- Internal testers must already be Users in App Store Connect; external testers can be any email.
