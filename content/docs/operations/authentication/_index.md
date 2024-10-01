---
title: Authentication
weight: 1
---

MKE uses [Dex](https://dexidp.io/) for authentication. Dex behaves as a proxy
between your MKE cluster and your authentication providers. Dex combines the
configuration of multiple authentication providers into a single configuration
and handles the complexity of the various protocols.

Mirantis Kubernetes Engine (MKE) supports the following authentication
protocols:

- OpenID Connect (OIDC)
- Security Assertion Markup Language (SAML)
- Lightweight Directory Access Protocol (LDAP)

## Prerequisites

You must have certain dependencies in place before you can configure
authentication. These dependencies differ, depending on which authentication
protocol you choose to deploy.

- **Identity Provider (IdP):** To use OIDC or SAML, you must configure an
  identity provider. Refer to [OIDC](../../operations/authentication/oidc-providers/oidc) or
  [SAML](../../operations/authentication/saml-providers/saml) for examples
  of using Okta as an authentication provider for either protocol.

- **LDAP Server:** To use LDAP, you must have an LDAP server configured. An
  example server on your local machine can be found at [LDAP](../../operations/authentication/ldap).

## Configuration

You configure authentication for MKE through the `authentication` section
of the MKE configuration file.

Authentication is is always enabled, however, the settings for each of the
individual authentication protocols are disabled. To enable and install an
authentication protocol, set its `enabled` configuration option to `true`.

```yaml
authentication:
  enabled: true
  ldap:
    enabled: false
  oidc:
    enabled: false
  saml:
    enabled: false
```

### Expiry

The `expiry` section of the configuration file allows you to set the expiration
time for refresh and id tokens. These should be set in the format of number +
time unit (e.g. `1h` for one hour).

```yaml
authentication:
  enabled: true
  expiry:
    refreshTokens: {}
```

| Field                                    | Description                                                                |
| ---------------------------------------- | -------------------------------------------------------------------------- |
| `expiry`                                 | The section for the various expiry settings                                |
| `expiry.idTokens`                        | The lifetime of the ID tokens                                              |
| `expiry.authRequests`                    | The time frame that a code can be exchanged for a token                    |
| `expiry.deviceRequests`                  | The time frame in which users can authorize a device to receive a token    |
| `expiry.signingKeys`                     | The time period after which the signing keys are rotated                   |
| `expiry.refreshTokens`                   | The section for the various refresh token settings                         |
| `expiry.refreshTokens.validIfNotUsedFor` | Invalidate a refresh token if it's not used for the specified time         |
| `expiry.refreshTokens.absoluteLifetime`  | Absolute time frame of a refresh token                                     |
| `expiry.refreshTokens.disableRotation`   | Disable every-request rotation                                             |
| `expiry.refreshTokens.reuseInterval`     | Interval to allow getting the same refresh token from the refresh endpoint |
