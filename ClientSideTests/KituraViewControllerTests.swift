/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import Foundation
@testable import ClientSide

class KituraViewControllerTests: XCTestCase {
    var viewController: KituraTableViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let rootViewController = storyboard.instantiateInitialViewController() as? UINavigationController {
            viewController = rootViewController.visibleViewController
                as? KituraTableViewController
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHelloWorldIsReturnedFromServer() {
        guard let viewController = viewController else {
            XCTFail("view controller should not be nil")
            return
        }
        let _ = viewController.view
        XCTAssertNotNil(viewController.view)
        viewController.kituraSwitch.setOn(true,animated: false)
        viewController.statusChanged(viewController.kituraSwitch)
        guard let url = URL(string: "http://localhost:8090") else {
            XCTFail()
            return
        }
        let helloExpectation = expectation(description: "GET \(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                XCTFail("data should not be nil")
                return
            }
            XCTAssertNil(error, "error should be nil")
            let stringData = String(data: data, encoding: String.Encoding.utf8)
            XCTAssertTrue(stringData?.hasPrefix("Hello, World!") ?? false)
            helloExpectation.fulfill()
        }

        task.resume()
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
}
