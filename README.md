# Campuswelle
The app for [Campuswelle](http://campuswelle.uni-ulm.de).

## Setting up
This project uses Carthage and CocoaPods.
In order to fetch all carthage dependencies run:

`
$ carthage update
`

Currently there is a client quick-fix the `BNRSSFeedParser`, because of syntactically invalid XML sent by the server. Therefore it is not recommended to update CocoaPods before fixing the XML.
You update CocoaPods with:

`
$ pod update
`

## Architecture

The `Storyboard.main` contains a graphical representation of the Application's `UIViewController`s. Additionally `PlaybackBarViewController.xib` visualizes the PlaybackBar that is going to be displayed.

The application fetches news from the RSS feed and maps them to podcasts or articles (that are still news). Later these will be embedded in a provided HTML Wrapper `wrapper.html` (its first `"%@"` is replaced by the article's title, the second one by its content).

- `PodcastPlayer` is a pure-swift, singleton class `sharedInstance`. It handles all playback logic and is capable of playing the default livestream and `Podcast`s.
- `News`-protocol, property `article`
- `Podcast`s and `Article`s are `News`

Some functional files:

- `news-data`: fetch news (podcasts/articles) from DOM or internet
- `podcast-data`: fetches only podcasts
- `articles-data`: fetches only articles

### Additions
- `SegueHandlerType` provides the ability of statically typed segues declared in `Storyboard.main`
- `concurrency` provides some convenience functions for concurrency. Its `main(_: () -> ())` should always be used when manipulating the interface since `UIKit` is not thread-safe.
- `common-vc` provides convenience functions to add the `listeningButton` to a `UIViewController`
- `AssetIdentifier`is an extension to `UIImage` in order to load images from `Images.xcassets` without force-unwrapping and letting the compiler check for typos in identifier names.

### Dependencies
This application requires the following dependencies:

- `Hpple` a HTML parser, MIT License
- `BNRSSFeedParser` a parser for RSS and podcast feeds, MIT License

### Deprecation

Relevant files excluded from target:

- `structural-fold-phase`

	initially used to parse RSS feed, but it wasn't robust enough for frequent changes of the inner article structure during development. 
	
	Instead use `news-html` and `WebViewWrapperDelegate`.
	



## Member Center
### Testing on Devices
In order to test `Campuswelle` on your iOS device, add it  to your developer devices by providing its UDID.

Thereafter it needs to be added to a newly created iOS Development Provisioning Profile.

Make sure, you selected the appropriate Developer Team and already changed it's App ID of the target.

### iOS App ID
When generating in Member Center, following Application Services must be enabled in Distribution and Development:

- Inter-App Audio: enables continuing playback when other applications are active

Currently the App ID is set to `com.conclurer.Campuswelle`, but it needs to change when migrating to another Developer Account.

### Provisioning Profile
The iOS Development profile will be managed automatically by Xcode.

In order to genrate a new iOS Distribution Profile in Member Center, use the same information provided under `README.md > Member Center > iOS App ID`.

### Screenshots

Screenshots for all devices are created by running:

`
$ snapshot
`
