# VersionUpdateChecker

App Store Version Update Checker

## Requirements

iOS 11.0+

### CocoaPods

```
pod 'VersionUpdateChecker'
```

For the latest updates use:
```
pod 'VersionUpdateChecker', :git => 'https://github.com/twodayslate/VersionUpdateChecker.git'
```

## Usage

``` swift
Bundle.main.hasAppStoreUpdate {
	(hasUpdate, newVersion, error) in 
	guard error == nil else {
		print("Error! \(error.localizedDescription)")
		return
	}

	if hasUpdate {
		print("An update to \(newVersion) is available")
	}
}
```
