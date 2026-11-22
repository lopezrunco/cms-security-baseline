# LiteSpeed Cache Plugin Configuration Checklist for WordPress Sites

**Last updated:** 04-11-2026

---

## 1: Cache

| Setting | Value | Comments |
|---|---|---|
| Enable Cache | ON | Main function. |
| Cache Logged-in Users | OFF | Prevents content from one logged-in user leaking to another. |
| Cache Commenters | OFF | Same reason. |
| Cache REST API | OFF | REST responses may contain private data. |
| Cache Login Page | OFF | Avoids stale nonces or tokens on the login page. |
| Cache Mobile | OFF | Enable only if the theme serves different HTML to mobile devices. |
| List of Mobile User Agents | Default | Only matters if Cache Mobile is ON. |
| Private Cached URIs | Empty | Manage sensitive routes in screen 4. |
| Force Cache URIs | Empty | Overrides the exclusions. |
| Force Public Cache URIs | Empty | Same as the previous one, and the riskiest. |
| Drop Query String | Default (`fbclid`, `gclid`, `utm*`, `_ga`) | Tracking parameters only. Never add parameters that change the content. |

## 2: TTL

| Setting | Value | Comments |
|---|---|---|
| Default Public Cache TTL (604800) | Keep, or lower to 86400 if content changes often | Not a vulnerability, but a shorter TTL limits how long stale pages live. |
| Default Private Cache TTL (1800) | Keep | Already short. |
| Default Front Page TTL (604800) | Keep | |
| Default Feed TTL (604800) | Keep | Feeds are public. |
| Default REST TTL (604800) | 0 | Defense in depth: disables REST caching even if someone enables Cache REST API later. |
| Default HTTP Status Code Page TTL (`404 3600`, `500 600`) | Keep | |

## 3: Purge

| Setting | Value | Comments |
|---|---|---|
| Purge All On Upgrade | ON | After a security update, cached pages and resources come from the already-patched code. |
| Auto Purge Rules For Publish/Update | Check all | Simplest and safest for a small site. |
| Serve Stale | OFF | By design it serves old copies. |
| Scheduled Purge URLs | Empty | Optional. |
| Scheduled Purge Time | Empty | |
| Purge All Hooks | Default | |

## 4: Excludes

| Setting | Value | Comments |
|---|---|---|
| Do Not Cache URIs | Add, one per line, booking and contact form paths such as `/contacto`, `/turnos`, `/reservar`, `/mi-cuenta`. | Keeps pages with forms and tokens out of the cache. |
| Do Not Cache Query Strings | Add whatever forms or plugins use to carry state, such as `token`, `session`, `key`. | Optional, but safe. |
| Do Not Cache Categories / Tags | Empty unless needed | |
| Do Not Cache Cookies | Add any cookies set by booking or form plugins, if any. | Avoids caching personalized responses. |
| Do Not Cache User Agents | Empty | |
| Do Not Cache Roles | Check Administrator, Editor, Author, Contributor | Maintenance roles should never receive cached pages. Also check Subscriber if there are real users with accounts. |

## 5: ESI

| Setting | Value | Comments |
|---|---|---|
| Enable ESI | OFF | Adds complexity and attack surface. Not needed if there is no public logged-in traffic. |
| Cache Admin Bar | OFF | |
| Cache Comment Form | OFF | |
| ESI Nonces | Leave as is | Only relevant if ESI is ON. |
| Vary Group | Leave (Administrator 99, the rest 0) | Only relevant if ESI is ON. |

If you ever enable ESI, re-test all forms and all logged-in views.

## 6: Object Cache

| Setting | Value | Comments |
|---|---|---|
| Object Cache | OFF | The Redis and Memcached extensions show as *Disabled*, so there is nothing to connect to. |
| Method / Host / Port / Username / Password / Redis Database ID | Leave defaults | Irrelevant while OFF. |
| Persistent Connection | OFF | |
| Cache WP-Admin | OFF | Stale data in the admin is a risk. |

If you enable it later, use Redis or Memcached on localhost or a UNIX socket. Require a password, never expose the port, and use a unique key prefix per site.

## 7: Browser Cache

| Setting | Value | Comments |
|---|---|---|
| Browser Cache | ON | Static files only. Note: edits `.htaccess`. |
| Browser Cache TTL (31557600 = approximately 1 year) | Keep if resources are versioned. Otherwise, use 604800. | One year is fine for versioned files and risky for unversioned ones. |

## 8: Advanced

| Setting | Value | Comments |
|---|---|---|
| AJAX Cache TTL | Empty | Caching AJAX actions can expose dynamic data. |
| Login Cookie | Default `_lscache_vary` | Change only if several WordPress installations share a domain. |
| Vary Cookies | Empty | |
| Improve HTTP/HTTPS Compatibility | OFF | Forces HTTPS across the whole site with HSTS in place. |
| Instant Click | OFF | Preloading generates extra GET requests and increases server load. |