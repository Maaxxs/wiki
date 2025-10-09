# RADIUS over UDP Considered Harmful

- Website is <https://blastradius.fail>
- Talk 2025: <https://www.youtube.com/watch?v=IgyK9QYRQMI>

2004: the first real MD5 collision.

Then the next stronger attack: MD5 identical prefix collision.
For example, see [Shattered](https://shattered.io/) for SHA-1.

Strongest attack: chosen-prefix attack.
Used in 2009 for a rogue TLS CA. Took 28 hours.

Due to Merkle-Damgård structure of MD5, we can append a suffix `s` to both "hashes" and still get the collision.
The *secret* extension in the RADIUS Response Authenticator field (last input to MD5) protects against *length-extension attacks*
but *not against collisions*.

They create a MD5 collision so that an Radius Access-Accept and Access-Reject message produce the same Response Authenticator.

The Blast-RADIUS attack works within 5 minutes on 47 servers with 10 year old hardware.
They say the attack parallels well, so it can be faster.

# Summary

* breaks PAP, CHAP, MS-CHAP
* EAP not vulnerable due to HMAC-MD5 attributes.

The correct way of doing RADIUS is RADIUS over TLS (RADIUS within a TLS/DTLS channel).



See IETF draft, 2023: [Deprecating Insecure Practices in RADIUS](https://datatracker.ietf.org/doc/draft-ietf-radext-deprecating-radius/).

