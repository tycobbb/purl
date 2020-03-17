#pragma once
#include <stdint.h>

typedef void *purl_t;
typedef void *purl_ctx_t;

purl_t purl_create();
void purl_destroy(purl_t purl);

typedef const char *purl_url_t;
typedef void (*purl_callback_t)(purl_ctx_t ctx, purl_url_t url);

purl_url_t purl_clean_url(purl_t purl, purl_url_t url, purl_callback_t callback, purl_ctx_t ctx);
void purl_destroy_url(purl_url_t url);
