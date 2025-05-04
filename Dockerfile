
# This passes all tests
# FROM cyberdojo/sinatra-base:759c4e9@sha256:d5f87f343a9f88a598b810c0f02b81db0bb67319701a956aec3577cbd51c1c24

# Next commit: This passes all tests
# FROM cyberdojo/sinatra-base:a903598@sha256:12f9997694fbc19acbdc2ac4c3e616ff5896c4e8e7bc5d37a961af2245e5e18d

# Next commit: This fails script-test test_duplicate_keys_in_json()
# FROM cyberdojo/sinatra-base:d8b8a99@sha256:0a4452c577b732d9ce88aa9e3e2fc898a50aee5ad9cc2b0ea425140a17a10884

# This is a version of sinatra-base with the last known working build_image.sh script restored
FROM cyberdojo/sinatra-base:eca4305@sha256:e40c4a0b92569f2260a1ab67e3d2438fa32aea8a14739ba84bb429d258290dd4

# FROM cyberdojo/sinatra-base:1552fae@sha256:402680b4f08344ee965c5905915b209e28fb469dd39c8d0854c1a0d109b78882
# The FROM statement above is typically set via an automated pull-request from the sinatra-base repo
LABEL maintainer=jon@jaggersoft.com

ARG SHA
ENV SHA=${SHA}

COPY . /
WORKDIR /app
HEALTHCHECK --interval=1s --timeout=1s --retries=5 --start-period=5s CMD ./healthcheck.sh
