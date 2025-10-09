# D(e)rive with Care

Talk: <https://www.youtube.com/watch?v=w3dpdVgT2ig>

Key Derivation function inputs
- secret + label + length
- salt

Output a new key.

They say that the salt is often just a fixed string and not an *actual salt*.

What are _labels_ and _contexts_?

- _one_ label is associated with final key (like purpose of key)
- multiple contexts: associated with component key. Say "public parameters, transcript"

Problem arises if e.g. HKDF does not expect a _label_ but a _context_.
Then the fixed label string is used as context.

Other KDF: MFKDF. Produces key with 100 bits of entropy.
There's a paper [MFKDP: Multiple Factors Knocked Down Flat](https://ia.cr/2024/935).

Shamir secret sharing, e.g. 2 out of 3: means 2 out of 3 Shamir secrets can derive the original key.

What is a secure multi-input KDF? (n-KDF)

## Security of deployed constructions

- MLS: good. PSK combiner seems good.
- ETSI CatKDF: label issue where the KDF gets the label that should rather be a context.
- Signal: X3DH KDF. Good.

