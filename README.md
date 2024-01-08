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

Note: in case the certificate does no longer work (expires Nv 28, 2025) then try to download the latest version from https://badssl.com/download/.

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
openssl pkcs12 -in ./ClientCertificateSwiftDemo/badssl.com-client.p12 -legacy -nodes -passin pass:"badssl.com" | openssl x509 -text -noout
```

Output

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            c9:fc:9e:a7:04:59:e9:0c
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, ST = California, L = San Francisco, O = BadSSL, CN = BadSSL Client Root Certificate Authority
        Validity
            Not Before: Nov 29 22:34:03 2023 GMT
            Not After : Nov 28 22:34:03 2025 GMT
        Subject: C = US, ST = California, L = San Francisco, O = BadSSL, CN = BadSSL Client Certificate
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
    Signature Value:
        28:75:b8:7d:5c:c7:e4:e1:30:92:6c:72:f8:54:00:a1:42:b1:
        ea:30:ae:38:7a:9a:c1:c6:c8:d0:29:64:7e:9c:37:71:7d:5c:
        25:eb:a0:72:04:ee:5d:3f:42:7c:dc:d8:0c:08:60:b5:5e:ba:
        8e:e6:c4:d0:b1:08:de:da:8f:5e:a7:0b:ea:e4:99:c3:fb:8f:
        94:a2:f4:b4:22:e9:fd:26:8b:e5:d7:b8:bf:ba:5b:1e:30:bd:
        ed:c3:e9:fb:9a:bf:1b:80:bc:bc:55:c4:e1:f4:db:33:73:06:
        f7:d3:c6:11:9a:b2:39:f1:c2:83:80:e1:b2:90:af:6f:f6:2c:
        6f:80:28:da:56:35:60:48:ee:e7:d3:26:25:b3:24:7d:d3:bb:
        e3:11:5a:c1:d1:7c:d8:db:81:29:ce:0a:a9:cb:da:bd:78:ed:
        1c:bf:2f:81:f5:e6:a4:30:b5:11:2b:50:26:7a:a1:a2:5b:33:
        5c:ef:6b:0b:d1:15:90:49:dd:16:05:5b:29:e6:4d:09:6a:f3:
        83:b3:5a:ac:b4:f7:5b:5b:47:a5:84:b0:0e:4c:63:5d:ad:8d:
        10:92:c1:32:5d:eb:ae:59:c6:21:95:e0:7b:b9:a5:98:17:e6:
        23:65:85:e2:08:4c:fa:19:c3:57:cb:73:82:af:43:16:14:02:
        60:f3:a3:75:c3:50:90:35:f3:eb:76:9d:e6:f5:50:60:75:91:
        03:50:55:c9:0b:c3:09:69:06:59:fb:08:5a:09:4a:2b:0c:81:
        ec:dc:e1:b6:aa:44:d2:05:40:6d:7d:33:db:81:46:92:32:ab:
        77:2e:71:7c:db:9e:78:8b:69:54:8c:bd:e6:3d:f1:6a:7d:55:
        7b:c2:e2:53:6f:44:ab:a1:c5:c7:83:58:a9:d9:48:79:1a:05:
        de:f0:1f:c2:2e:1f:6f:c4:bd:59:f7:39:89:18:42:eb:4e:16:
        cf:6d:30:77:dc:85:54:cb:a8:8e:57:2d:5b:d8:0f:ac:ec:c4:
        8b:ec:db:0d:0a:1a:cc:4c:a9:e5:e8:4b:c9:be:47:f1:8b:9a:
        9a:69:d8:d4:d0:46:3e:19:86:e3:3e:6c:aa:b6:cb:02:12:91:
        31:21:11:0c:e4:2f:c2:23:00:4b:fa:3d:f7:7e:2c:b5:a1:c0:
        98:5b:54:4c:16:76:e1:fd:71:1d:ca:36:54:b8:38:6b:60:d0:
        46:5a:96:7d:e0:88:6b:b6:2d:42:0e:92:20:6c:74:ce:72:66:
        58:50:69:d3:1d:b0:36:6b:88:89:16:16:37:14:2b:0c:1b:2e:
        af:e8:99:5f:16:22:5b:b4:1c:0f:e4:94:dc:70:9e:38:a1:35:
        c3:1b:48:ac:c4:0a:d1:09
```







