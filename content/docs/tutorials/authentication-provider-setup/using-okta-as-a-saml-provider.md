---
title: Using Okta as a SAML provider
weight: 1
---

This example demonstrates how to set up Okta as a SAML provider for MKE 4. For the full list of SAML configurations, see the [SAML](../../../../docs/operations/authentication/saml) documentation.

## Set up a SAML application in Okta

Navigate to (Okta)[https://www.okta.com/] and sign in to your accounts dashboard.

1. Select **SAML 2.0** for **Sign-in method**.
2. For **App name**, choose a name that you can easily remember.
3. Configure the host for your redirect URLs:
   - Single sign-on URL: `http://{MKE hostname}/callback`
   - Audience URI (SP Entity ID): `http://{MKE hostname}/callback`
   - Attribute statements:
     - Name: email
       <br>Value: user.email
     - Name: name
       <br>Value: user.login
4. Click **Save**.
5. Click **Finish**.
6. Navigate to the **Assignments** tab:
   a. Click **Assign** -> **Assign to people**.
   b. Click the blue **Assign** button that corresponds to the account you want to use for authentication.
   Okta generates the `ssoURL` and certificate under the `Sign On` tab.
   The `ssoURL` is the MetadataURL with the final metadata removed from the path.
7. Download the certificate to the system from which you will run mkectl:
   a. Navigate to the SAML **Signing Certificates** section.
   b. Click **Actions** for the active certificate and initiate the download.
8. Run the `mkectl apply` command with your MKE configuration file.

## Test authentication flow

1. Navigate to the MKE dashboard: `https://{MKE hostname}`
2. Select **Log in with OIDC**. This will redirect you to Okta's
   login page for your application.
3. Enter your credentials and click **Sign In**. If authentication is successful,
   you will be redirected to the MKE dashboard.
