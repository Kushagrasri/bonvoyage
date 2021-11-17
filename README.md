# Bon Voyage

<img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Frontend%20Files/assets/apphead.png" width=100>

***Make your journey a memory.***

Do you ever wonder what places your friends visit? Do you have a list of places that you want to visit but can't track them? ***Bon Voyage*** helps you with all of it!

Bon Voyage keeps track of all the places you and your friends have visited or want to visit in the future. The cherry on top is that we do it all on a map! 

Bon Voyage is a mobile application with cross platform support built on Flutter, i.e., it can run on both Android and iOS! We provide a login/signup system where we use Sendgrid to send OTP on your email for a one-time verification.

As a user, you can -
* Follow other users and accept follow requests from other users
* Save places you have visited
* Save places you want to visit
* See your friends' visited places
* See the places your friends want to visit
* Add bookmarks about your visited places (eg. suggestions to try out Paneer Tikka Masala at a certain restaurant for people to see)
* Keep your account public (anyone can see your locations) or private (only friends can see your locations)

Places are stored on a Google Map in the Flutter app using the [google-maps-flutter](https://pub.dev/packages/google_maps_flutter) package provided by Flutter. Thanks to [Google](https://www.google.com) for providing an amazing API platform!

Places can be of two types-
- Visited     <img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Frontend%20Files/assets/custompin.png" width=30>
- Unvisited   <img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Frontend%20Files/assets/addLoc.png" width=30>

All places can have an optional comment where the user whose visit this is, can specify their views/suggestions of that place and this would be displayed over the marker on the map.

Here is a [demo video](https://drive.google.com/file/d/1dINP3BG_8gH21rZ0TKCRyB8JRPj9wH23/view?usp=sharing) of the app which displays the basic functionalities of the app in development phase. 

Some screenshots of the app are attached - 

<img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/1.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/2.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/3.1.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/3.2.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/4.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/5.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/6.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/7.jpg" width=100><img src="https://github.com/Kushagrasri/bonvoyage/blob/master/Images/8.jpg" width=100>

### Here is a link to the [Postman Collection](https://www.getpostman.com/collections/c4ed9cb727a4f87ad46a) of Bon Voyage.

### Tech Used -
```
Node.js
Express.js
MongoDB
Flutter
Google Maps API
Sendgrid API
```

## Usage

```bash
npm install
npm run dev 
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


# Contributors 

[Kushagra Srivastava](https://github.com/Kushagrasri)

[Varun Saini](https://github.com/varun-saini-18)
