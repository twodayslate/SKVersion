import XCTest

import SKVersionTests

var tests = [XCTestCaseEntry]()
tests += VersionUpdateTests.allTests()
XCTMain(tests)
