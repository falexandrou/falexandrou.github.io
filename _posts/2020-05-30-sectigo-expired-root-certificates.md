---
layout: post
comments: true
title: "How to fix Sectigo's expired root certificates"
author: Fotis
---

As of today (May 30th 2020), Sectigo's root certificates that are usually bundled with any SSL purchase (in my case it was on February 2020, just 3 months ago), are due to expire.
Here's a short post on how to deal with this, so that you don't pull your hair as I did.

### The problem
You might not be able to identify the issue at once, the browser will display the SSL certificate just fine as it's still valid, however if you have any `curl` calls or in my case,
alerting software such as Pingdom or OpsGenie, you will be getting alerts.

I initially thought it was some system issue but turns out it wasn't, once I ran an [SSL test via SSL Labs](https://www.ssllabs.com/ssltest){:target="_blank"} which showed my intermediate certificates as expired.

### The solution
 - Head over to this [support announcement from Sectigo](https://support.sectigo.com/articles/Knowledge/Sectigo-AddTrust-External-CA-Root-Expiring-May-30-2020){:target="_blank"} and don't get lured by the "You don’t have to reinstall your certificates" thing. It's clear that it only refers to sites that are being accessed through browsers.
 - Scroll down and try to identify the modern roots (COMODO RSA/ECC Certification Authority and USERTrust RSA/ECC Certification Authority) and pick the one according to your Certification Authority.
 - On the pages that open, search for "Download" and download the new roots. Weirdly enough, you'll get file names that only contains digits. Rename them to `USERTrustRSAAddTrustCA.crt` and `AddTrustExternalCARoot.crt` accordingly.
 - Find (or download again) your SSL certificate package, and copy the folder with a different name (eg. `STAR_hudabeauty_com_new_sectigo_root`)
 - Replace the files `AddTrustExternalCARoot.crt` and `USERTrustRSAAddTrustCA.crt` with the ones you had just downloaded
 - Chain the certificate again using the order required. On a *nix system the command should look something like that:

 ````
 cat YOUR_certificate_name.crt AddTrustExternalCARoot.crt SectigoRSADomainValidationSecureServerCA.crt USERTrustRSAAddTrustCA.crt > YOUR_chained_certificate.crt
 ````
 - You now have a new SSL certificate in place, you can copy it over to your server or use it in your Certificate Manager (if you're using any).

Hope this saved you some time.

PS. Speaking of saved time, how would you like to save tons of time in your next project, by automating your infrastructure using our tool for effortless cloud deployments called [Stackmate.io](https://stackmate.io){:target="_blank"}? Join our [waiting list](https://stackmate.io/#subscribe) and we'll let you know once we launch!
