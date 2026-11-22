# Maintenance and Updates

**Applies to:** All sites that use `WordPress` or `Joomla`.  
**Last updated:** 23-07-2026

---

## Backup policy

| Frequency | Responsible | Type |
|---|---|---|
| Weekly (automatic) | Hosting provider | Full backup from `cPanel` |
| Monthly | Developer | Full backup from `cPanel` |
| Before making changes to the site | Developer | Full backup from `cPanel` |
| Before updating plugins/theme/CMS | Developer | Full backup from `cPanel` |
| After confirming that updates are stable | Developer | Full backup from `cPanel` |

Automatic updates must be **disabled on all sites**. This applies to the CMS, plugins, and theme.

All plugins, themes, and the CMS core (`WordPress`/`Joomla`) will be reviewed and updated **monthly** by the developer responsible for the site.
 
**Backup storage:** Download locally, verify integrity (for example, using [Docker](./docs/Runbook:%20WordPress%20Backup%20Restoration.md)), and store both locally and in an external location (cloud or external drive). Do not rely solely on the hosting provider's copy.

**Recommended backup retention for developers**

- **Last 3 manual backups:** This means a before/after of recent changes without accumulating too much space.

- **Last clean backup after an incident:** If malware reappears, it is imperative to have a clean baseline for restoration. This backup is never deleted unless the site has been free of incidents for a period of 6 months.

---

## Monthly update checklist

- [ ] Manual backup before starting.
- [ ] Open the admin dashboard and check available updates.
- [ ] Check the versions of installed components against the `WPScan` and VEL (Vulnerable Extensions List) vulnerability databases to identify known vulnerabilities (`CVE`). 
- [ ] Apply updates one at a time, checking the site each time.
- [ ] Apply updates in the following order: 
    1. Plugins 
    2. Theme 
    3. CMS.
- [ ] Clear the cache after updating.
- [ ] Verify that the site loads correctly on mobile and desktop.
- [ ] Create a manual backup after confirming that the updates are stable.
- [ ] Run a security scan (`WPScan`, `Imunify Security`, or the equivalent in `cPanel`).
- [ ] Review plugin security alerts.

---

## Backup log

Each developer is responsible for maintaining a log of their sites' backups.

A log template is provided at [`templates/backup-log.md`](./templates/backup-log.md).

---