1. Run this script, replacing the API token obtained from WPScan:

```sh
wpscan --url https://website.com.uy \
  --enumerate vp,vt,u \
  --plugins-detection mixed \
  --api-token [WPSCAN_API_TOKEN] \
  --random-user-agent \
  --throttle 500 \
  -o cve-scan-results.txt
```

2. Search for alerts: 

```sh
grep "\[!\]" cve-scan-results.txt
```