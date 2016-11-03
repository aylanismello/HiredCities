# Hired Cities


### Up And Running

`git clone`

`bundle install`

`ruby hired.rb`



### What's Happening

To find the distance between two latitude/longitude coordinates on the globe,
we must compute a non-euclidean distance called [orthodromic distance](https://www.wikiwand.com/en/Great-circle_distance).
This is abstracted away in the geokit ruby gem I used which did the mathematical heavy lifting.


**NOTE**

- This program should take roughly 3-5 minutes to complete depending on your bandwidth speed.
- *If you are greeted with ever annoying quota exceeded error...*

### Fun along the way 😅

![OhNo](exceeded_quota.png)


### External gems

* geokit (wrapper around Google Maps API)
* ruby-progressbar
* dotenv
