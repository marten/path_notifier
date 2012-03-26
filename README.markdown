# Latitude Notifier

Reads a real-time stream of location data from Google Latitude, and notifies
you when you're nearing a POI along a route on which you frequently stop at
this POI.

Location data is saved in MongoDB, and we use the MongoDB geo-features to find
POIs automatically based on places you visit frequently.

## Things to do:

- Import data from GeoLoqi
- Automatically detect POIs
- Automatically detect routes
  - For each point, we have a direction that we get over the API
    Find nearest point at timestamp > current point, and in that direction?
- Automatically detect forks in those routes
  - Radial scan for points that are within a few degrees of eachother?

## Other services that are interesting

GeoLoqi

- https://developers.geoloqi.com/api/console?method=location/last
