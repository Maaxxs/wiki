# Firefox

## Hardware Accelerated Video

### Installation and Activation

Install Intel driver and optionally Intel GPU tools to watch GPU
activity.

    pacman -S intel-media-driver intel-gpu-tools
    sudo intel_gpu_top


Enable hardware accelerated video in Firefox in `about:config`

    media.ffmpeg.vaapi.enabled = true


### Optional

**I did not have to do this. It just worked out of the box with the
settings above.**

These are settings in Firefox `about:config`.

Disable software decoders (they supposedly overrule hardware accelerated
video)

    media.ffvpx.enabled = false

> Needed due to Firefox trying to put some video decoding in a remote
> video process. This currently breaks accelerated VP8/VP9 video
> decoding:

    media.rdd-vpx.enabled to false

Enable hardware decoding for WebRTC

    media.navigator.mediadatadecoder_vpx_enabled to true
