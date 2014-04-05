Twikee
======

# Purpose
Twikee is a library to help you promote your app or game by using the most effective marketing technique : Twitter spreading.
You can use it by providing extra content (unblock features, extra lifes, etc) to users in exchange for an advertising tweet about your app.

# Installation
Simply drag Twikee.h and Twikee.m into your project and you are ready to go.

# How to use
## Methods
Twikee should exclusively be used through his singleton method
```ios
+ (instancetype)sharedInstance;
```
Before trying to disply Twikee, you should consider using the following method
```ios
- (BOOL)canSendTweet;
```
This will return `NO` if there is no Twitter account binded to device.
Then, you are ready to go with 
```ios
- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage prefixMessage:(NSString *)prefixMessage;
```
This will display an `UIAlertView` with the title you passed on the parameter `title`. `tweetMessage` is the advertising tweet you want the user to send and `prefixMessage` is only an informative text to display (will not be sent with the tweet).
Example : 
```ios
[[Twikee sharedInstance] showWithTitle:@"Send a promoted tweet to unlock a life ?"
                          tweetMessage:@"Checkout the new Death Fire game @deathfire bit.ly/XXXXX"
                         prefixMessage:@"Preview : "];
```
You can also use the following method if you don't need `prefixMessage` : 
```ios
- (void)showWithTitle:(NSString *)title tweetMessage:(NSString *)tweetMessage;
```

## Delegate
`TwikeeDelegate` provides methods that can be used to intercept events. All those methods are optional.
```ios
- (BOOL)twikeeShouldDisplay;
- (void)twikeeWillDisplay;
- (void)twikeeDidDisplay;
- (void)twikeeDidCancel;
- (void)twikeeDidSendTweet:(NSString *)tweet;
- (void)twikeeDidFailWithError:(NSError *)error;
```

# Release Notes
Version 1.0
* Initial release
