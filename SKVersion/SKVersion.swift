//
//  VersionUpdate.swift
//  VersionUpdate
//
//  Created by Zachary Gorak on 9/11/19.
//  Copyright © 2019 Zac Gorak. All rights reserved.
//

import Foundation
import Version

extension Bundle {
    /// The App Store version of the bundle.
    public var storeVersion: SKVersion? {
        guard let bundleId = self.bundleIdentifier else {
            return nil
        }
        
        return SKVersion(bundleId, version: self.version)
    }
}

/// Aoo Store Version Update Checker
/// - SeeAlso: https://stackoverflow.com/questions/6256748/check-if-my-app-has-a-new-version-on-appstore
open class SKVersion {
    /// URL used to check for new version results
    open var endpoint: URL? {
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(self.bundleId)")
        return url
    }
    
    /// Bundle Identifier
    public let bundleId: String
    // version to compare against
    private var _latestVersion: Version? = nil
    public var current: Version

    public var latest: Version? {
        get {
            if _latestVersion == nil {
                self.update()
            }
            return _latestVersion
        }
    }
    
    /// - parameters:
    ///     - bundleId: bundle identifier
    ///     - version: Initial version
    public init(_ bundleId: String, version: Version? = nil) {
        self.bundleId = bundleId
        self.current = version ?? Bundle(identifier: bundleId)?.version ?? Version("0.0")
    }
    
    /// Session used for creating the data task
    public var session = URLSession.shared
    
    /// Checks if there is an App Store update
    /// - parameters:
    ///     - block: callback
    ///     - canUpdate: Whether or not an update is available on the App Store
    ///     - version: App Store Version available
    ///     - error: Any potential errors
    open func update(completion block: ((_ canUpdate: Bool, _ version: Version?, _ error: Error?)->Void)? = nil) {
        guard let checkUrl = self.endpoint else {
            block?(false, nil, URLError(.badURL))
            return
        }
        
        self.session.dataTask(with: checkUrl) { (data, response, error) in
            guard error == nil else {
                block?(false, nil, error)
                return
            }
            
            do {
                
                guard let reponseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any],
                    let result = (reponseJson["results"] as? [Any])?.first as? [String: Any],
                    let versionString = result["version"] as? String
                    else{
                        block?(false, nil, URLError(.badServerResponse))
                        return
                }
                
                let liveVersion = try VersionParser(strict: false).parse(string: versionString)
                
                if(liveVersion > self.current) {
                    self._latestVersion = liveVersion
                }
                
                block?(self.current < liveVersion, liveVersion, nil)
                return
            } catch {
                block?(false, nil, error)
                return
            }
        }.resume()
    }
}
