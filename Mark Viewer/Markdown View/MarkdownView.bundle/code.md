### Swift

```swift
import Foundation

@objc class Person: Entity {
  var name: String!
  var age:  Int!

  init(name: String, age: Int) {
    /* /* ... */ */
  }

  // Return a descriptive string for this person
  func description(offset: Int = 0) -> String {
    return "\(name) is \(age + offset) years old"
  }
}
```

### Objective-C

```objective-c
#import <UIKit/UIKit.h>
#import "Dependency.h"

@protocol WorldDataSource
@required
- (BOOL)allowsToLive;
@end

@property (nonatomic, readonly) NSString *title;
- (IBAction) show;

// Sample method
- (void)sample(NSString *text) {
    if ([text hasPrefix:@"http"]) {
        NSLog(@"HTTP");
    } else {
        NSLog(@"Not HTTP");
    }
}
```
