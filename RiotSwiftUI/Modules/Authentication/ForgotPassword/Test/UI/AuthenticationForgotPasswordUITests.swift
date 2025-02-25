//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest
import RiotSwiftUI

class AuthenticationForgotPasswordUITests: MockScreenTest {

    override class var screenType: MockScreenState.Type {
        return MockAuthenticationForgotPasswordScreenState.self
    }

    override class func createTest() -> MockScreenTest {
        return AuthenticationForgotPasswordUITests(selector: #selector(verifyAuthenticationForgotPasswordScreen))
    }

    func verifyAuthenticationForgotPasswordScreen() throws {
        guard let screenState = screenState as? MockAuthenticationForgotPasswordScreenState else { fatalError("no screen") }
        switch screenState {
        case .emptyAddress:
            verifyEmptyAddress()
        case .enteredAddress:
            verifyEnteredAddress()
        case .hasSentEmail:
            verifyWaitingForEmailLink()
        }
    }
    
    func verifyEmptyAddress() {
        XCTAssertTrue(app.staticTexts["titleLabel"].exists, "The title should be shown before an email is sent.")
        XCTAssertTrue(app.staticTexts["messageLabel"].exists, "The message should be shown before an email is sent.")
        
        let addressTextField = app.textFields["addressTextField"]
        XCTAssertTrue(addressTextField.exists, "The text field should be shown before an email is sent.")
        XCTAssertEqual(addressTextField.value as? String, "Email Address", "The text field should be showing the placeholder before text is input.")
        
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should be shown before an email is sent.")
        XCTAssertFalse(nextButton.isEnabled, "The next button should be disabled before text is input.")

        let doneButton = app.buttons["doneButton"]
        XCTAssertFalse(doneButton.exists, "The done button should be hidden before an email has been sent.")

        let resendButton = app.buttons["resendButton"]
        XCTAssertFalse(resendButton.exists, "The done button should be hidden before an email has been sent.")
        
        XCTAssertFalse(app.staticTexts["waitingTitleLabel"].exists, "The waiting title should be hidden until an email is sent.")
        XCTAssertFalse(app.staticTexts["waitingMessageLabel"].exists, "The waiting message should be hidden until an email is sent.")

        let cancelButton = app.navigationBars.firstMatch.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be shown.")
        XCTAssertEqual(cancelButton.label, "Cancel")
    }
    
    func verifyEnteredAddress() {
        XCTAssertTrue(app.staticTexts["titleLabel"].exists, "The title should be shown before an email is sent.")
        XCTAssertTrue(app.staticTexts["messageLabel"].exists, "The message should be shown before an email is sent.")
        
        let addressTextField = app.textFields["addressTextField"]
        XCTAssertTrue(addressTextField.exists, "The text field should be shown before an email is sent.")
        XCTAssertEqual(addressTextField.value as? String, "test@example.com", "The text field should show the email address that was input.")
        
        let nextButton = app.buttons["nextButton"]
        XCTAssertTrue(nextButton.exists, "The next button should be shown before an email is sent.")
        XCTAssertTrue(nextButton.isEnabled, "The next button should be enabled once an address has been input.")

        let doneButton = app.buttons["doneButton"]
        XCTAssertFalse(doneButton.exists, "The done button should be hidden before an email has been sent.")

        let resendButton = app.buttons["resendButton"]
        XCTAssertFalse(resendButton.exists, "The done button should be hidden before an email has been sent.")
        
        XCTAssertFalse(app.staticTexts["waitingTitleLabel"].exists, "The waiting title should be hidden until an email is sent.")
        XCTAssertFalse(app.staticTexts["waitingMessageLabel"].exists, "The waiting message should be hidden until an email is sent.")

        let cancelButton = app.navigationBars.firstMatch.buttons["cancelButton"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be shown.")
        XCTAssertEqual(cancelButton.label, "Cancel")
    }
    
    func verifyWaitingForEmailLink() {
        XCTAssertFalse(app.staticTexts["titleLabel"].exists, "The title should be hidden once an email has been sent.")
        XCTAssertFalse(app.staticTexts["messageLabel"].exists, "The message should be hidden once an email has been sent.")
        XCTAssertFalse(app.textFields["addressTextField"].exists, "The text field should be hidden once an email has been sent.")
        XCTAssertFalse(app.buttons["nextButton"].exists, "The next button should be hidden once an email has been sent.")

        let doneButton = app.buttons["doneButton"]
        XCTAssertTrue(doneButton.exists, "The done button should be hidden once an email has been sent.")
        XCTAssertTrue(doneButton.isEnabled)

        let resendButton = app.buttons["resendButton"]
        XCTAssertTrue(resendButton.exists, "The resend button should be hidden once an email has been sent.")
        XCTAssertTrue(resendButton.isEnabled)
        
        XCTAssertTrue(app.staticTexts["waitingTitleLabel"].exists, "The waiting title should be shown once an email has been sent.")
        XCTAssertTrue(app.staticTexts["waitingMessageLabel"].exists, "The waiting title should be shown once an email has been sent.")

        let backButton = app.navigationBars.firstMatch.buttons["cancelButton"]
        XCTAssertTrue(backButton.exists, "Back button should be shown.")
        XCTAssertEqual(backButton.label, "Back")
    }

}
