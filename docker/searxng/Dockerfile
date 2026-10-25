# Validation only. Deploy the unmodified upstream image selected by Compose.
ARG SEARXNG_IMAGE
FROM ${SEARXNG_IMAGE} AS validation
COPY scripts/check_ca_trust.py docker/searxng/validate_image.py /opt/cosmos-trust/
COPY tests/fixtures/ca-trust/incident.json /opt/cosmos-trust/incident.json
RUN /usr/local/searxng/.venv/bin/python /opt/cosmos-trust/validate_image.py

FROM validation AS live-validation
RUN /usr/local/searxng/.venv/bin/python /opt/cosmos-trust/validate_image.py --live
