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

import Foundation
import UIKit

extension KituraTableViewController {
    class Colors {
        static let Running = Colors.uiColor(fromHexadecimalString: "#7ed321")
        static let Stopped = Colors.uiColor(fromHexadecimalString: "#9b9b9b")
        static let LogBar = UIColor(red: CGFloat(32/255.0), green: CGFloat(147/255.0),
                                    blue: CGFloat(224/255.0), alpha: 1.0)
        static let MainStatusBar = UIColor(red: CGFloat(32/255.0), green: CGFloat(147/255.0),
                                           blue: CGFloat(224/255.0), alpha: 0.84)

        private static func uiColor (fromHexadecimalString hexadecimalString: String) -> UIColor {
            var hexadecimalString =
                hexadecimalString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if hexadecimalString.hasPrefix("#") {
                hexadecimalString.remove(at: hexadecimalString.startIndex)
            }

            guard hexadecimalString.characters.count == 6 else {
                return UIColor.gray
            }

            return uiColor(fromRGBValue: rgbValue(fromHexadecimalString: hexadecimalString))
        }

        private static func rgbValue(fromHexadecimalString string: String) -> UInt32 {
            var rgbValue: UInt32 = 0
            Scanner(string: string).scanHexInt32(&rgbValue)
            return rgbValue
        }

        private static func uiColor(fromRGBValue rgbValue: UInt32) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
}
