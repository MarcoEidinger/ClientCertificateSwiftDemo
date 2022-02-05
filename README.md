# Client Certificate Handling on iOS Demo
Explanation and Demonstration of Client Certificate Authentication on iOS.

https://user-images.githubusercontent.com/4176826/152642471-2201fbe2-b799-4da5-8997-d0f90fa497df.mp4

Complete YouTube video: https://youtu.be/qSzk-gMsFZ4

# What is it?

**Client Certificate Authentication** is a mutual certificate-based authentication, where the client provides its Client Certificate to the server to prove its identity. This happens as a part of the SSL Handshake (*optional*).

![How Mutal Authentication Works](https://www.thesslstore.com/blog/wp-content/uploads/2021/05/how-mutual-authentication-works.png)

## How it works with ... ?

### URLSession

`URLSessionDelegate` is required which implements [`URLSession:didReceiveChallenge:completionHandler:`](https://developer.apple.com/documentation/foundation/nsurlsessiondelegate/1409308-urlsession) and returns [`URLCredential`](https://developer.apple.com/documentation/foundation/urlcredential/1418121-init) instance to resolve a client certificate authentication challenge.

### WKWebView

`WKNavigationDelegate` is required which implements [`webView(_:didReceive:completionHandler:)`](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455638-webview) and returns [`URLCredential`](https://developer.apple.com/documentation/foundation/urlcredential/1418121-init) instance to resolve a client certificate authentication challenge.

### SafariViewController

Works when certificate was installed on the device in the Apple keychain access group.

### Open link in Safari

Works when certificate was installed on the device in the Apple keychain access group.

## Why apps cannot rely on installed certificates through Safari, Email or MDM ?

>  Users can install digital identities (certificates plus their associated private keys) onto their iOS devices by downloading them from within Safari, by opening them as email attachments, and by installing them with configuration profiles. Or, identities can be pushed from a Mobile Device Management (MDM) server. However, identities installed in any of these ways are added to the Apple keychain access group.

>  Apps can only access keychain items in their own keychain access groups. This means that items in the Apple access group are only available to Apple-provided apps such as Safari or Mail.

>  To use digital identities in your own apps, you will need to write code to import them. This typically means reading in a PKCS#12-formatted blob and then importing the contents of the blob into the app's keychain using the function `SecPKCS12Import` documented in [Certificate, Key, and Trust Services Reference](https://developer.apple.com/documentation/security/1396915-secpkcs12import).

>  This way, your new keychain items are created with your app's keychain access group.

Source: [Technical Q&A QA1745 - Making Certificates and Keys Available To Your App](https://developer.apple.com/library/archive/qa/qa1745/_index.html) 

## Demo App

iOS application to demonstrate the use of a client certificate for authentication.

Use this app to access  https://client.badssl.com/ in various ways

- URLSession.dataTask
- WKWebView
- SFSafariViewController
- Open link in Safari

Website https://client.badssl.com/ requires a valid user certificate. Otherwise server returns HTTP 400.

For convenience, I added `badssl.com-client.p12` (downloaded from https://badssl.com/download/) as a bundle resource. This allows you to test the successful authentication with a user certificate using `URLSession` and `WKWebView`.

Note: in case the certificate does no longer work (expires Dec 4, 2023) then try to download the latest version from https://badssl.com/download/.

## Acknowledgments

- https://badssl.com/ (open-source: https://github.com/chromium/badssl.com)

- [Client certificate with URLSession in Swift](https://leenarts.net/2020/02/28/client-certificate-with-urlsession-in-swift/)

- [WKWebView with client certificate](https://gist.github.com/tempire/1e6191e810636a638d0f203c8240d2b8)

- [WKWebView in SwiftUI](https://tigi44.github.io/ios/iOS,-SwiftUI-WKWebView/)

## More Details about Client Certificate

A **Client Certificate** is a *digital certificate* which confirms to the [X.509](http://en.wikipedia.org/wiki/X.509) system. A certificate contains an identity (a hostname, or an organization, or an individual) and a public key (RSA, DSA, ECDSA, ed25519, etc.), and is either signed by a [certificate authority](https://en.wikipedia.org/wiki/Certificate_authority) or is self-signed. It is used by client systems to prove their identity to the remote server.

The certificate public key as well as the correspinding private keya  is stored in a`.p12` files. The container format is password protected and therefore fully encrypted (unlike `.pem` files).

This is a password-protected container format that contains both public and private certificate pairs. Unlike .pem files, this container is fully encrypted.

You can use the `openssl` library to decrypt the p12 file, access the certificate or private key information and transform them. For example, to decode the certificate information stored in the encrypted file.

Input

```bash
openssl pkcs12 -in ./ClientCertificateSwiftDemo/badssl.com-client.p12 -nodes -passin pass:"badssl.com" | openssl x509 -text -noout
```

Output

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 17726285331827515185 (0xf6006a9766cbdf31)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=California, L=San Francisco, O=BadSSL, CN=BadSSL Client Root Certificate Authority
        Validity
            Not Before: Dec  4 00:08:19 2021 GMT
            Not After : Dec  4 00:08:19 2023 GMT
        Subject: C=US, ST=California, L=San Francisco, O=BadSSL, CN=BadSSL Client Certificate
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c7:37:5f:11:eb:1e:4e:cf:eb:ba:48:e5:cb:a3:
                    12:2c:73:3e:46:1d:1e:9c:0d:c0:8b:83:23:da:c7:
                    65:df:5c:77:49:b3:e8:7a:7d:3c:ba:d5:61:8c:f9:
                    a5:c4:85:1d:92:23:06:e3:e7:df:7b:b3:7e:26:d0:
                    cb:1b:be:42:6b:16:69:f4:2c:72:b5:7e:e4:cb:0a:
                    28:44:12:6c:46:74:21:99:03:dc:6b:c3:11:58:02:
                    41:23:3f:b0:fc:bf:b7:00:59:13:22:a5:81:7f:24:
                    fe:d5:53:bc:4d:52:8f:90:4a:46:74:b0:e8:bd:93:
                    a6:cd:90:00:4a:2f:7f:b2:3f:a3:ea:03:3b:01:a0:
                    a2:0d:e6:53:7f:61:12:eb:a6:9b:03:9a:4e:a7:ad:
                    10:e8:e1:1d:c2:0f:ef:09:42:5f:6a:b8:4a:0e:98:
                    bd:b6:3d:cf:ea:a4:e8:cb:d6:38:0e:20:54:84:e7:
                    2d:e0:c1:bc:c3:95:f0:98:a0:02:f9:57:e6:f2:d6:
                    fb:b4:c8:94:a1:4d:32:bc:a2:8e:70:be:98:5c:15:
                    f1:07:69:0f:70:e6:31:60:da:1b:5d:ab:df:54:11:
                    1d:c1:2a:e3:43:b8:bf:b3:7a:3a:86:41:90:96:6f:
                    45:ec:93:c4:b9:58:1b:97:f2:5d:c1:ae:b8:39:82:
                    2a:8d
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            Netscape Cert Type:
                SSL Client
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment
    Signature Algorithm: sha256WithRSAEncryption
         19:4b:36:8b:c5:bd:2a:d4:2e:02:ef:26:62:97:fd:ba:12:59:
         03:a1:58:4d:07:0d:7e:9b:54:ac:93:b3:8f:20:7f:bc:b7:0d:
         74:8e:0f:e6:c7:90:13:47:2f:48:5e:9b:81:d1:15:26:ab:8f:
         ec:77:f3:da:22:3c:4b:62:e6:2d:76:36:0f:4e:2c:b1:f0:48:
         72:be:ec:07:e7:ae:48:4b:1c:0f:0c:2f:73:56:c3:41:81:af:
         90:e0:76:c2:2f:ec:c2:5d:18:8a:d7:3d:0c:13:37:98:fe:f8:
         80:b2:63:9f:3c:4d:f1:87:1f:cb:d4:e6:a6:f9:3e:b4:aa:0a:
         52:d9:49:21:d4:d3:91:53:af:f0:dc:d4:1f:21:2a:38:e5:77:
         f1:4a:3a:27:4b:a3:56:03:2c:55:23:68:1f:71:d6:66:4f:52:
         27:3f:0b:8f:3d:97:23:df:5a:a3:ea:a0:c4:5d:e6:2f:d7:4a:
         14:93:e4:53:ef:7c:6b:8a:45:de:6a:5c:a0:e4:ae:7f:86:69:
         0f:f8:88:30:dd:0a:07:a4:0c:20:8f:84:ec:2e:ba:56:af:37:
         10:43:8d:28:70:66:dd:53:79:4a:d9:35:23:37:53:81:9e:65:
         fc:ab:54:12:2e:4e:bf:a0:04:ae:08:90:3f:5d:fe:f3:fb:b1:
         ad:8d:42:cc:c5:d3:04:50:b7:79:b5:c2:f4:96:c4:fc:fd:d5:
         e1:fe:31:05:35:74:d3:f3:83:58:67:42:02:8a:22:b5:02:35:
         36:9b:fc:20:26:49:07:ca:0b:5b:61:47:5e:6c:3e:0e:5b:13:
         49:30:25:dd:40:27:50:2a:4e:b6:31:23:45:48:4d:45:7c:1a:
         46:b7:b5:20:29:dd:a2:99:d8:b0:60:81:81:cb:23:64:6f:f6:
         35:de:e5:8c:79:0d:c9:1f:de:5f:98:48:5a:7f:dd:d4:83:90:
         53:a0:12:e6:66:d8:57:d9:97:8b:cd:05:1f:9c:a2:88:69:07:
         df:b6:8d:15:8b:2b:ee:1f:22:40:89:6d:af:98:d9:c1:1d:e6:
         eb:09:13:5f:0c:4c:7f:45:53:f2:4a:0f:0c:c2:f9:e3:bd:48:
         d2:c5:53:0d:f3:19:4b:12:c2:06:6c:04:73:fa:92:24:0d:b2:
         e8:9a:f6:ae:0c:e5:ff:ba:f2:4c:cc:e3:ed:0d:53:c1:f0:c3:
         2c:d9:12:d9:93:06:19:2d:28:78:a3:13:18:b1:76:f8:e5:30:
         06:7c:84:03:ac:16:27:ec:7a:f2:34:d3:67:54:62:fb:71:a0:
         76:9e:5e:1e:23:a5:81:d5:36:7b:08:7f:fe:f8:b8:b6:a0:88:
         f1:ed:55:fe:fe:f5:46:55
```







