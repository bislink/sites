// Sites, /service-worker.js

// version: 028

'use strict';

const CACHE_NAME = 'Sites.202807102433';
const DATA_CACHE_NAME = 'Sites.202807102433';

const FILES_TO_CACHE = [

];

self.addEventListener('install', (evt) => {
  console.log('Sites Install');
    // CODELAB: Precache static resources here.
    evt.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('Sites Pre-caching offline page');
            return cache.addAll(FILES_TO_CACHE);
        })
    );

  self.skipWaiting();
});

self.addEventListener('activate', (evt) => {
  console.log('Sites Activate');
    // CODELAB: Remove previous cached data from disk.
    evt.waitUntil(
        caches.keys().then((keyList) => {
            return Promise.all(keyList.map((key) => {
                if (key !== CACHE_NAME && key !== DATA_CACHE_NAME) {
                    console.log('Sites Removing old cache', key);
                    return caches.delete(key);
                }
            }));
        })
    );

  self.clients.claim();
});

self.addEventListener('fetch', (evt) => {
  console.log('Sites Fetch', evt.request.url);
    // CODELAB: Add fetch event handler here.
    if (evt.request.url.includes('/')) {
        console.log('Sites Fetch (data)', evt.request.url);
        evt.respondWith(
            caches.open(DATA_CACHE_NAME).then((cache) => {
                return fetch(evt.request)
                    .then((response) => {
                        // If the response was good, clone it and store it in the cache.
                        if (response.status === 200) {
                            cache.put(evt.request.url, response.clone());
                        }
                        return response;
                    }).catch((err) => {
                        // Network request failed, try to get it from the cache.
                        return cache.match(evt.request);
                    });
            }));
        return;
    }
    evt.respondWith(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.match(evt.request)
                .then((response) => {
                    return response || fetch(evt.request);
                });
        })
    );

});
