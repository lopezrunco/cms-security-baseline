1. Correr este script en la terminal, reemplazando el API token obtenido en WPScan:

```sh
wpscan --url https://psicologosenmontevideo.uy \
  --enumerate vp,vt,u \
  --plugins-detection mixed \
  --api-token [WPSCAN_API_TOKEN] \
  --random-user-agent \
  --throttle 500 \
  -o resultado_cves.txt
```

2. Buscar por alertas: 

```sh
grep "\[!\]" resultado_cves.txt
```