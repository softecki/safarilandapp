'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "83278c71b629bed5adadd56f9d257f93",
"assets/AssetManifest.bin.json": "63d56f7a286a1efb6d06fe5ff5ef91dd",
"assets/AssetManifest.json": "18ee958b10e6933ad6c6b3d90636da7f",
"assets/assets/images/a53_1.png": "76abb2a2695e40e0dde2227799e4e3c8",
"assets/assets/images/a53_2.png": "f0c16ce4fc29536eecaa0fff2a847d6e",
"assets/assets/images/a53_3.png": "25ed4697ddbc84f77568367c477aa00f",
"assets/assets/images/airtel.png": "8f517ce2c5206827cb3fad47bba5b155",
"assets/assets/images/akiba.png": "be10e56cbc16ff684d91af449fb63a7f",
"assets/assets/images/amana.png": "bf6e7a183dbc2c46df0e237eb4ddc271",
"assets/assets/images/anorld.jpg": "e23095adabb9c3e70654788e6e231171",
"assets/assets/images/apple_watch_series_7_1.png": "6896b7b12420f45ae00d09c64effa94a",
"assets/assets/images/apple_watch_series_7_2.png": "ee8b64160b5afc7b8566757ea6dac229",
"assets/assets/images/apple_watch_series_7_3.png": "448cd0f21417a512ae5ce3cf0d8d7308",
"assets/assets/images/beats_studio_3-1.png": "2a52813a4c72af683516e01f9b6f6c48",
"assets/assets/images/beats_studio_3-2.png": "b7a1563b5d7cbd11334fec308e33bea7",
"assets/assets/images/beats_studio_3-3.png": "c221dc33472cb538bd808a973389d75b",
"assets/assets/images/beats_studio_3-4.png": "809b4dc0f4c2f433964531f70485dfee",
"assets/assets/images/crdb.png": "2abd5835fbc5bdb2a311d39eeab6443e",
"assets/assets/images/empty_cart.png": "3e647f6309f275fbfc2dd0024f0d65ac",
"assets/assets/images/faidabiz_logo.png": "2974e178d74c053ef6744826c939da6f",
"assets/assets/images/galaxy_watch_4_1.png": "8610803e40ffa156b545313174100836",
"assets/assets/images/galaxy_watch_4_2.png": "3ac712a0ece907293b552a69e7abe455",
"assets/assets/images/galaxy_watch_4_3.png": "db79c9be0476af37683dce8a1b70ea79",
"assets/assets/images/github.png": "8c647d3383cfc379f5cbb2dc4f023eea",
"assets/assets/images/halopesa.png": "25834b467b1241ac6eb05705e4ba25df",
"assets/assets/images/logo.png": "2e81df60ee9b965cd811d8cc2a2a0087",
"assets/assets/images/logo_n.png": "2e81df60ee9b965cd811d8cc2a2a0087",
"assets/assets/images/lotigas_logo.png": "d43ede65d744591a1c10da68596d6136",
"assets/assets/images/m.png": "ad839062177697029e9a18586a9b6e75",
"assets/assets/images/malipo_mtandao.png": "74b16cd5c88fb4e8501e7c3058d478bc",
"assets/assets/images/malipo_mtandao1.png": "b7bc14c319c837f7889d28aba875e9ca",
"assets/assets/images/mkombozi.png": "3873376c647b2291eb13ad43c7fb56fb",
"assets/assets/images/mpesa.png": "b92f1b47bbd2b9b9c77ee22691369258",
"assets/assets/images/mwalimu.png": "58d978ce4b48947946b3d81b97684bfd",
"assets/assets/images/mwanga.png": "00af933ee9b4367850945296bd7a9910",
"assets/assets/images/nalopa.png": "c8cab5090a043da600beb2b528ceacde",
"assets/assets/images/nariva.png": "1b54b275d68568e349ecca74ccba1660",
"assets/assets/images/nmb.png": "c89b4cc8c403804d5ca5d72336a7fb16",
"assets/assets/images/profile_pic.png": "8bc312b4a517860a66276b12fac675fd",
"assets/assets/images/samsung_q_60_a_1.png": "0668882764b8cf75abc1a50a2315f8cc",
"assets/assets/images/samsung_q_60_a_2.png": "e086c8857473f05e0cd491625b1afc8e",
"assets/assets/images/shopping.png": "e404ea63a735bc645816c330361bf8e8",
"assets/assets/images/sony_x_80_j_1.png": "0b8edd2e3ccde0db9a8485af8a249e9c",
"assets/assets/images/sony_x_80_j_2.png": "c22fabd184247075072d4bd90204570c",
"assets/assets/images/stagret.PNG": "828b772eec4c9ec07551f3ed00d16a2a",
"assets/assets/images/tab_s7_fe_1.png": "1a7ed93c366ae61d094b5d5ff4b20f7a",
"assets/assets/images/tab_s7_fe_2.png": "8f208d8b3a3bf89da7acf916dda691b9",
"assets/assets/images/tab_s7_fe_3.png": "2c57e5bb56c9091ff0e05fe042044273",
"assets/assets/images/tab_s8_1.png": "8e7ddcae4573f5ed0315c4baed1d37ac",
"assets/assets/images/tab_s8_2.png": "651d974e8bacfd75b7941541924a99f8",
"assets/assets/images/tab_s8_3.png": "7ae76358b5d01279c2ca73e65ef8044f",
"assets/assets/images/tcb.png": "0256c91ee7bd548ba2932c2636a2c81a",
"assets/assets/images/ticket_mtandao.png": "fe1ff2c6e50c20419188b2dbf1021d3c",
"assets/assets/images/tigo.png": "256118222418329deaa33a13933962c2",
"assets/assets/images/wicom.png": "1e2832f512f257137bb315cc1dba52b1",
"assets/assets/translations/en.json": "ea43775d2909db7e96bf81c54595c94d",
"assets/assets/translations/sw.json": "e24a7f861dc064ee207cec486cb4b450",
"assets/FontManifest.json": "46da055cfd1999f8792c7e5d29f45292",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "21686435dfaae6c0b78501c2af905291",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/flutter_neumorphic_plus/fonts/NeumorphicIcons.ttf": "32be0c4c86773ba5c9f7791e69964585",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"drift_worker.js": "326046c109d7503a96c8695c19f5c853",
"faidabiz_logo.png": "2974e178d74c053ef6744826c939da6f",
"favicon.png": "2974e178d74c053ef6744826c939da6f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "a2dd75bcfca65fab5cfd3ea3767926ad",
"icons/Icon-192.png": "2974e178d74c053ef6744826c939da6f",
"icons/Icon-512.png": "2974e178d74c053ef6744826c939da6f",
"icons/Icon-maskable-192.png": "2974e178d74c053ef6744826c939da6f",
"icons/Icon-maskable-512.png": "2974e178d74c053ef6744826c939da6f",
"index.html": "b154e5d55c3f19c5e1127d19a9d848d0",
"/": "b154e5d55c3f19c5e1127d19a9d848d0",
"lotigas_logo.png": "d43ede65d744591a1c10da68596d6136",
"main.dart.js": "2fbe9551fdb8a639dc013ebafa841c87",
"manifest.json": "5be0ce2871338d682e46ee61257f659e",
"sql-wasm.js": "9b629335d3339b01f5b0b1ff22774d55",
"sql-wasm.wasm": "adf3b772bd5b646d050ce90d58b3db23",
"sqlite3.wasm": "51739179fd57f102da5297192df613e7",
"sw.js": "96bbe82dd7625264cd1ee40b3b5a4b51",
"version.json": "4d80a421465b07a26db6ccfe92674021"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
