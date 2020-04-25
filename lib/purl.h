#pragma once
#include <stdint.h>
#include <stdbool.h>

// -- types --
typedef void *purl_t;

typedef void *purl_ctx_t;
typedef uint32_t purl_id_t;
typedef void (*purl_add_cb_t)(purl_id_t id, purl_ctx_t ctx);

typedef const void *purl_queue_t;
typedef const void *purl_url_t;
typedef const char *purl_uri_t;
typedef const char *purl_err_t;

// -- purl --
purl_t
purl_create();

void
purl_destroy(purl_t purl);

bool
purl_add_url(purl_t purl, purl_uri_t uri, purl_add_cb_t callback, purl_ctx_t ctx);

purl_queue_t
purl_get_queue(purl_t purl);

// -- queue --
purl_id_t
purl_queue_size(purl_queue_t queue);

bool
purl_queue_loading(purl_queue_t queue);

purl_url_t
purl_queue_get_url(purl_queue_t, purl_id_t id);

// -- url --
void
purl_url_drop(purl_url_t);

purl_uri_t
purl_url_initial(purl_url_t url);

purl_uri_t
purl_url_cleaned_ok(purl_url_t url);

purl_err_t
purl_url_cleaned_err(purl_url_t url);

// -- uri --
void
purl_uri_drop(purl_uri_t uri);

void
purl_err_drop(purl_err_t err);
