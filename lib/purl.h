#pragma once
#include <stdint.h>

typedef void *purl_ctx_t;
typedef const char *purl_string_t;
typedef void (*purl_callback_t)(purl_ctx_t ctx, purl_string_t url);

purl_string_t purl_clean_url(purl_string_t url, purl_callback_t callback, purl_ctx_t ctx);
void purl_free_url(purl_string_t url);
