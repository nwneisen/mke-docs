---
title: OIDC
weight: 2
---

You configure OIDC (OpenID Connect) for MKE 4 through the `authentication.oidc`
section of the MKE configuration file.

OIDC example configuration:

```yaml
authentication:
  enabled: true
  oidc:
    enabled: true
    issuer: https://dev-94406016.okta.com
    clientID: 0oedtjcjrjWab3zlD5d4
    clientSecret: DFA9NYLfE1QxwCSFkZunssh2HCx16kDl41k9tIBtFZaNcqyEGle8yZPtMBesyomD
    redirectURI: http://dex.example.com:32000/callback
```

## Configure OIDC service for MKE

In the MKE configuration file `authentication.oidc` section, enable your
OIDC service by setting `enabled` to `true`. Use the remaining fields, which
are defined in the following table, to configure your chosen OIDC provider.

{{< callout type="info" >}}
For information on how to obtain the field values, refer to the [OIDC provider example](../../../tutorials/authentication-provider-setup/oidc-provider-setup).
{{< /callout >}}

| Field          | Description                                                          |
| -------------- | -------------------------------------------------------------------- |
| `issuer`       | OIDC provider root URL.                                              |
| `clientID`     | ID from the IdP application configuration.                           |
| `clientSecret` | Secret from the IdP application configuration.                       |
| `redirectURI`  | URI to which the provider will return successful authentications to. |

For more information, refer to the official DEX documentation
[OIDC configuration](https://dexidp.io/docs/connectors/oidc/#configuration).

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Click **Login** to display the login page.
3. Select **Log in with OIDC**. This will redirect you to the OIDC provider's
   login page.
4. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
