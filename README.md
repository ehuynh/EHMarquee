# EHMarquee

EHMarquee helps create an automatic scrolling UILabel for text that is larger than its container.

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## How it works

Create a `UILabel` and set it as the `contentLabel` on `EHMarqueeCOntainerView`. That's it.

### SomeView.m
```Objective-C
    EHMarqueeContainerView *marqueeContainerView = [[EHMarqueeContainerView alloc] init];
    [self addSubview:marqueeContainerView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Looooong amount of text that needs scrolling."
```

EHMarquee uses AutoLayout/Constraints to scroll the UILabel. The code has not been tested when setting Frames explicity, so it is advised to use AutoLayout for views that use EHMarquee.

Run the EHMarqueeExample app to see it in action.
## Requirements

iOS 7.0+

## Installation

EHMarquee is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "EHMarquee"

## Author

Edward Huynh, edward@edwardhuynh.com

## License

EHMarquee is available under the MIT license. See the LICENSE file for more info.
