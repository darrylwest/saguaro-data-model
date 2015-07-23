# Saguaro Data Model

<a href="https://developer.apple.com/swift/"><img src="http://raincitysoftware.com/swift-logo.png" alt="swift" width="64" height="64" border="0" /></a>

_A swift 2.0 set of data modeling tools for iOS/OSX applications_

<a href="https://developer.apple.com/swift/"><img src="http://raincitysoftware.com/swift2-badge.png" alt="" width="65" height="20" border="0" /></a>
[![Build Status](https://travis-ci.org/darrylwest/saguaro-data-model.svg?branch=master)](https://travis-ci.org/darrylwest/saguaro-data-model)

## Features

Saguaro Data Model provides...

* base data model protocols for use in document type databases, e.g., redis, mongo, couch, et
* data model implementations using structs
* JSON parse and stringify for base models
* data model utilities including unique ids and regular expression overloads

## Installation

* pod 'SaguaroDataModel', :git => 'https://github.com/darrylwest/saguaro-data-model.git'
* git subproject/framework (from repo)

## How to use

### SADocumentIdentifier

The struct SADocumentIdentifier is used to encapsolate id, date created, last updated, and version attributes.  Using this standard identifier makes it easy to send and recieve data from non-SQL databases like redis.  Here is a standard use:

```
let doi = SADocumentIdentifier()

print( doi.id ) // 84ef623b5d2c4fd69b5f6722a54cd22e <- a GUID like unique id
print( doi.dateCreated ) // an NSDate
print( doi.lastUpdated ) // another NSDate
print( doi.version ) // an int == 0

assert( doi.dateCreated == doi.lastUpdated )

assert( SADocumentIdentifier() != doi ) // compare against another doi

doi.updateVersion()
assert( doi.version == 1 )
assert( doi.dateCreated < doi.lastUpdated )
```

## License: MIT

Use as you wish.  Please fork and help out if you can.

- - -
darryl.west@raincitysoftware.com | Version 00.90.10
