# Beeline

## Inspiration
My friend's brother has a great idea for cyclists: a smart-compass that allows you to hone in on your destination, exploring the city and turning every journey into a treasure hunt. [See the video](https://www.youtube.com/watch?v=pNguieZ4cTc).
 
## What it does
Imagine you're a cyclist. You want a heads-up display that will get you to your destination, without getting in your way, or forcing you down a fixed path. You want to ride free, but you still have somewhere to be. So you enter your destination into Beeline, and get a smart compass that will point the way. You always know how far you have to go, and where you're headed. Beyond that, you're free to explore your city.

## How I built it
Elm, a rising star in the React-like webapps. It's statically-typed, functional, fast and fun. Coupled with the Esri Geocoding API and the HTML5 location & orientation APIs, we can build a smart compass in less than a day.

## Challenges I ran into
Degrees are not Radians. Sine is not Cosine. This is probably for the best in the long run, but getting the distance and bearing calculations was probably harder than the coding.

## Accomplishments that I'm proud of
This is a fast, real app that could be used today. I'm hugely interested in doing real-world things with Elm, and this feels like a big win Rewriting and refactoring was incredibly easy.

Plus...my friend's brother - the source of the idea - I hope will be thrilled to see the first signs of his dream coming to life...

## What I learned
Interop between Elm and the device APIs is much easier than I expected. But the APIs are pretty unreliable, giving results that are inconsistent between browsers, and inconsistent with the API. It's nice to have the kind of compile-time checks for this that JavaScript can't provide.

## What's next for Beeline
Hopefully, a hardware Kickstarter, turning this software proof of concept into a real magic widget for the cyclists of the world.
