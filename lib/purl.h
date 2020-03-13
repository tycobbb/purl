#pragma once
#include <stdint.h>

typedef const char *purl_string_t;

purl_string_t purl_clean_url(purl_string_t url);
void purl_free_url(purl_string_t url);
