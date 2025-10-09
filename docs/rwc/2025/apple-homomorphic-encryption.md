# Apple’s Real World Deployment of HE at Scale

Talk: <https://www.youtube.com/watch?v=goQA0dO0M7c>

- Using Homomorphic encryption directly does not work.
    - Sending the ciphertext and receiving the response produces ~17 MB of network traffic. Not viable on an iPhone.
    - privacy: ok.

What is differential privacy?

- They use clustering to divide the embedding space into clusters.
    - Necessary to do nearest neighbor search.
- Then the iPhone sends a Embedding and Apples server responds with the entire cluster.
- This improves the fact that Apple cannot learn from the embedding itself privacy-protected information. (Lots of research has shown that a simple embedding reveals more or less everything about the input. So this must be protected.)
    - But the server learns the nearest cluster which is already too much of info about the user.
- They also batch the requests of users.

- The second guy says that they _require an anonymization network_ and then says they use _Oblivious HTTP_. Lol. "It remove identifying information such as the client's IP address" he says.
- iPhone also sends certain number of fake queries (binomial normal distribution).
- Other potential leakage: timing. iPhone select random windows of timings where it sends the real or fake queries. This timing is okay for "offline" photo tagging.
- Proof details at <https://arxiv.org/abs/2406.06761>

Conclusion - Enhanced Visual Search

| | Technique | Queries per Second | Communication per Query |
| :-- | :-- | --: | --: |
| Apple's results   | HE + DP + Anonymization Network | >25,000 | 0.56 MB |
| Tiptoe        | Additive HE                       | 909   | 17.4 MB |


Open Source Server HE Implementation

- server side: <https://github.com/apple/swift-homomorphic-encryption>
- device side HE implementation: Corecrypto <https://developer.apple.com/security/#corecrypto>
- [Combining Machine Learning and Homomorphic Encryption in the Apple Ecosystem](https://machinelearning.apple.com/research/homomorphic-encryption)
- [Scalable Private Search with Wally](https://machinelearning.apple.com/research/wally-search)

