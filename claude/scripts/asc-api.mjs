// Minimal App Store Connect API client (global, app-agnostic).
// Usage: node ~/.claude/scripts/asc-api.mjs GET '/v1/apps?filter[bundleId]=...'
//        node ~/.claude/scripts/asc-api.mjs PATCH /v1/... '<json body>'
// Auth:
//   - Private key: ~/.appstoreconnect/private_keys/AuthKey_<KEYID>.p8
//     KEYID from $ASC_KEY_ID, else auto-detected if exactly one key present.
//   - Issuer:  $ASC_ISSUER_ID (required).
import { createPrivateKey, sign } from 'node:crypto';
import { readFileSync, readdirSync } from 'node:fs';
import { homedir } from 'node:os';

const keyDir = `${homedir()}/.appstoreconnect/private_keys`;

const KEY_ID =
  process.env.ASC_KEY_ID ??
  (() => {
    const keys = readdirSync(keyDir).filter(
      (f) => f.startsWith('AuthKey_') && f.endsWith('.p8')
    );
    if (keys.length !== 1)
      throw new Error(
        `Set ASC_KEY_ID (found ${keys.length} keys in ${keyDir})`
      );
    return keys[0].slice('AuthKey_'.length, -'.p8'.length);
  })();

const issuer =
  process.env.ASC_ISSUER_ID ??
  (() => {
    try {
      return readFileSync(`${keyDir}/issuer_id`, 'utf8').trim();
    } catch {
      return undefined;
    }
  })();
if (!issuer)
  throw new Error(
    `Set ASC_ISSUER_ID env var or write it to ${keyDir}/issuer_id`
  );

const key = createPrivateKey(
  readFileSync(`${keyDir}/AuthKey_${KEY_ID}.p8`)
);

const b64 = (obj) => Buffer.from(JSON.stringify(obj)).toString('base64url');

function jwt() {
  const header = b64({ alg: 'ES256', kid: KEY_ID, typ: 'JWT' });
  const now = Math.floor(Date.now() / 1000);
  const payload = b64({
    iss: issuer,
    iat: now,
    exp: now + 1200,
    aud: 'appstoreconnect-v1',
  });
  const signature = sign('sha256', Buffer.from(`${header}.${payload}`), {
    key,
    dsaEncoding: 'ieee-p1363', // JWT wants raw r||s, not DER
  }).toString('base64url');
  return `${header}.${payload}.${signature}`;
}

const [method = 'GET', path = '/v1/apps', body] = process.argv.slice(2);
const res = await fetch(`https://api.appstoreconnect.apple.com${path}`, {
  method,
  headers: {
    Authorization: `Bearer ${jwt()}`,
    'Content-Type': 'application/json',
  },
  body: body || undefined,
});
const text = await res.text();
console.log(res.status);
try {
  console.log(JSON.stringify(JSON.parse(text), null, 2));
} catch {
  console.log(text);
}
