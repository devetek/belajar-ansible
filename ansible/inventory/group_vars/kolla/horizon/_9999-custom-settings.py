# Trust HTTPS from reverse proxy
USE_X_FORWARDED_HOST = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# Cookies must match HTTPS
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# Prevent bad redirects
SESSION_COOKIE_SAMESITE = 'Lax'
CSRF_COOKIE_SAMESITE = 'Lax'

# 🔑 THIS FIXES "not match any trusted origins"
CSRF_TRUSTED_ORIGINS = [
    'https://homelab-openstack.beta.devetek.app',
]

WEBROOT = '/'