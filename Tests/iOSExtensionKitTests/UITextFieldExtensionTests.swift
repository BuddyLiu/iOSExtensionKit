// UITextFieldExtensionTests.swift
// 测试UITextField扩展功能

import XCTest
@testable import iOSExtensionKit

#if canImport(UIKit)
import UIKit

final class UITextFieldExtensionTests: XCTestCase {
    
    var textField: UITextField!
    
    override func setUp() {
        super.setUp()
        textField = UITextField()
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    // MARK: - 链式设置测试
    
    func testChainingProperties() {
        // 测试链式设置属性
        textField
            .placeholder("请输入文本")
            .textColor(.red)
            .font(UIFont.systemFont(ofSize: 16))
            .alignment(.center)
            .borderStyle(.roundedRect)
        
        XCTAssertEqual(textField.placeholder, "请输入文本")
        XCTAssertEqual(textField.textColor, .red)
        XCTAssertEqual(textField.font, UIFont.systemFont(ofSize: 16))
        XCTAssertEqual(textField.textAlignment, .center)
        XCTAssertEqual(textField.borderStyle, .roundedRect)
    }
    
    func testSystemFontSetting() {
        textField.systemFont(size: 20, weight: .bold)
        
        guard let font = textField.font else {
            XCTFail("字体不应该为nil")
            return
        }
        
        XCTAssertEqual(font.pointSize, 20)
        XCTAssertTrue(font.fontDescriptor.symbolicTraits.contains(.traitBold))
    }
    
    // MARK: - 文本操作测试
    
    func testSafeText() {
        // 初始状态文本为nil
        XCTAssertEqual(textField.safeText, "")
        
        textField.text = "Hello"
        XCTAssertEqual(textField.safeText, "Hello")
        
        textField.text = nil
        XCTAssertEqual(textField.safeText, "")
    }
    
    func testTrimmedText() {
        textField.text = "  Hello World  "
        XCTAssertEqual(textField.trimmedText, "Hello World")
        
        textField.text = "\nHello\t"
        XCTAssertEqual(textField.trimmedText, "Hello")
        
        textField.text = nil
        XCTAssertEqual(textField.trimmedText, "")
    }
    
    func testIsTextEmpty() {
        textField.text = "   "
        XCTAssertTrue(textField.isTextEmpty)
        
        textField.text = ""
        XCTAssertTrue(textField.isTextEmpty)
        
        textField.text = "Hello"
        XCTAssertFalse(textField.isTextEmpty)
        
        textField.text = nil
        XCTAssertTrue(textField.isTextEmpty)
    }
    
    func testTextLength() {
        textField.text = "Hello"
        XCTAssertEqual(textField.textLength, 5)
        
        textField.text = "  Hello  "
        XCTAssertEqual(textField.textLength, 5) // 修剪后长度
        
        textField.text = nil
        XCTAssertEqual(textField.textLength, 0)
    }
    
    func testAppendText() {
        textField.text = "Hello"
        textField.appendText(" World")
        XCTAssertEqual(textField.text, "Hello World")
    }
    
    func testPrependText() {
        textField.text = "World"
        textField.prependText("Hello ")
        XCTAssertEqual(textField.text, "Hello World")
    }
    
    func testSetTextWithEvent() {
        var eventTriggered = false
        textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        textField.setTextWithEvent("New Text")
        
        // 由于我们无法直接测试事件是否触发，我们至少确保文本被设置
        XCTAssertEqual(textField.text, "New Text")
    }
    
    @objc private func handleEditingChanged() {
        // 用于测试事件触发
    }
    
    // MARK: - 输入验证测试
    
    func testIsValidEmail() {
        textField.text = "test@example.com"
        XCTAssertTrue(textField.isValidEmail)
        
        textField.text = "user.name@domain.co.uk"
        XCTAssertTrue(textField.isValidEmail)
        
        textField.text = "invalid-email"
        XCTAssertFalse(textField.isValidEmail)
        
        textField.text = "@example.com"
        XCTAssertFalse(textField.isValidEmail)
        
        textField.text = nil
        XCTAssertFalse(textField.isValidEmail)
    }
    
    func testIsValidChineseMobile() {
        textField.text = "13800138000"
        XCTAssertTrue(textField.isValidChineseMobile)
        
        textField.text = "13912345678"
        XCTAssertTrue(textField.isValidChineseMobile)
        
        textField.text = "1234567890"
        XCTAssertFalse(textField.isValidChineseMobile) // 位数不够
        
        textField.text = "23800138000"
        XCTAssertFalse(textField.isValidChineseMobile) // 错误开头
        
        textField.text = nil
        XCTAssertFalse(textField.isValidChineseMobile)
    }
    
    func testIsNumeric() {
        textField.text = "12345"
        XCTAssertTrue(textField.isNumeric)
        
        textField.text = "123abc"
        XCTAssertFalse(textField.isNumeric)
        
        textField.text = "12.3"
        XCTAssertFalse(textField.isNumeric) // 包含小数点
        
        textField.text = nil
        XCTAssertFalse(textField.isNumeric)
    }
    
    func testIsAlphabetic() {
        textField.text = "Hello"
        XCTAssertTrue(textField.isAlphabetic)
        
        textField.text = "Hello123"
        XCTAssertFalse(textField.isAlphabetic)
        
        textField.text = "Hello World"
        XCTAssertFalse(textField.isAlphabetic) // 包含空格
        
        textField.text = nil
        XCTAssertFalse(textField.isAlphabetic)
    }
    
    func testIsAlphanumeric() {
        textField.text = "Hello123"
        XCTAssertTrue(textField.isAlphanumeric)
        
        textField.text = "Hello_123"
        XCTAssertFalse(textField.isAlphanumeric) // 包含下划线
        
        textField.text = "Hello 123"
        XCTAssertFalse(textField.isAlphanumeric) // 包含空格
        
        textField.text = nil
        XCTAssertFalse(textField.isAlphanumeric)
    }
    
    func testIsValidLength() {
        textField.text = "Hello"
        
        XCTAssertTrue(textField.isValidLength(min: 0, max: 10))
        XCTAssertTrue(textField.isValidLength(min: 5, max: 5))
        XCTAssertFalse(textField.isValidLength(min: 6, max: 10))
        XCTAssertFalse(textField.isValidLength(min: 0, max: 4))
    }
    
    // MARK: - 样式设置测试
    
    func testAddBorder() {
        textField.addBorder(color: .red, width: 2)
        
        XCTAssertEqual(textField.layer.borderColor, UIColor.red.cgColor)
        XCTAssertEqual(textField.layer.borderWidth, 2)
    }
    
    func testRoundCorners() {
        textField.roundCorners(radius: 10)
        
        XCTAssertEqual(textField.layer.cornerRadius, 10)
        XCTAssertTrue(textField.layer.masksToBounds)
    }
    
    func testPadding() {
        let originalFrame = textField.frame
        textField.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        
        textField.padding(10)
        
        XCTAssertNotNil(textField.leftView)
        XCTAssertEqual(textField.leftViewMode, .always)
        
        if let paddingView = textField.leftView {
            XCTAssertEqual(paddingView.frame.width, 10)
        }
    }
    
    func testLeftIcon() {
        let image = UIImage(systemName: "magnifyingglass") ?? UIImage()
        textField.leftIcon(image, tintColor: .blue, padding: 8)
        
        XCTAssertNotNil(textField.leftView)
        XCTAssertTrue(textField.leftView is UIImageView)
        XCTAssertEqual(textField.leftViewMode, .always)
        
        if let iconView = textField.leftView as? UIImageView {
            XCTAssertEqual(iconView.image, image)
            XCTAssertEqual(iconView.tintColor, .blue)
        }
    }
    
    func testRightIcon() {
        let image = UIImage(systemName: "xmark.circle") ?? UIImage()
        textField.rightIcon(image, tintColor: .red, padding: 8)
        
        XCTAssertNotNil(textField.rightView)
        XCTAssertTrue(textField.rightView is UIImageView)
        XCTAssertEqual(textField.rightViewMode, .always)
        
        if let iconView = textField.rightView as? UIImageView {
            XCTAssertEqual(iconView.image, image)
            XCTAssertEqual(iconView.tintColor, .red)
        }
    }
    
    // MARK: - 键盘操作测试
    
    func testKeyboardOperations() {
        // 注意：这些测试在单元测试环境中可能无法完全执行
        // 因为它们涉及UI交互，但我们至少可以测试方法的存在
        
        // 测试是否响应该方法（不会实际显示键盘）
        textField.showKeyboard()
        XCTAssertTrue(textField.canBecomeFirstResponder)
        
        textField.hideKeyboard()
        XCTAssertTrue(textField.canResignFirstResponder)
    }
    
    func testIsEditingText() {
        // 在测试环境中，文本字段不是第一响应者
        XCTAssertFalse(textField.isEditingText)
    }
    
    // MARK: - 工厂方法测试
    
    func testEmailFieldFactory() {
        let emailField = UITextField.emailField(placeholder: "请输入邮箱")
        
        XCTAssertEqual(emailField.placeholder, "请输入邮箱")
        XCTAssertEqual(emailField.keyboardType, .emailAddress)
        XCTAssertEqual(emailField.autocapitalizationType, .none)
        XCTAssertEqual(emailField.autocorrectionType, .no)
    }
    
    func testPasswordFieldFactory() {
        let passwordField = UITextField.passwordField(placeholder: "请输入密码")
        
        XCTAssertEqual(passwordField.placeholder, "请输入密码")
        XCTAssertTrue(passwordField.isSecureTextEntry)
        XCTAssertEqual(passwordField.autocapitalizationType, .none)
        XCTAssertEqual(passwordField.autocorrectionType, .no)
    }
    
    func testPhoneFieldFactory() {
        let phoneField = UITextField.phoneField(placeholder: "请输入手机号")
        
        XCTAssertEqual(phoneField.placeholder, "请输入手机号")
        XCTAssertEqual(phoneField.keyboardType, .phonePad)
    }
    
    func testSearchFieldFactory() {
        let searchField = UITextField.searchField(placeholder: "搜索")
        
        XCTAssertEqual(searchField.placeholder, "搜索")
        XCTAssertEqual(searchField.layer.cornerRadius, 8)
        XCTAssertEqual(searchField.layer.borderWidth, 1)
        XCTAssertNotNil(searchField.leftView)
    }
    
    // MARK: - 链式样式测试
    
    func testStyledAsRoundedBorder() {
        textField.styledAsRoundedBorder(cornerRadius: 10, borderColor: .green, borderWidth: 2)
        
        XCTAssertEqual(textField.layer.cornerRadius, 10)
        XCTAssertEqual(textField.layer.borderColor, UIColor.green.cgColor)
        XCTAssertEqual(textField.layer.borderWidth, 2)
        XCTAssertEqual(textField.leftViewMode, .always)
    }
    
    func testStyledAsUnderline() {
        textField.styledAsUnderline(color: .blue, height: 2)
        
        XCTAssertEqual(textField.borderStyle, .none)
        
        // 检查是否添加了下划线视图
        let hasUnderlineView = textField.subviews.contains { view in
            view.backgroundColor == .blue && view.frame.height == 2
        }
        XCTAssertTrue(hasUnderlineView)
    }
    
    // MARK: - 边界条件测试
    
    func testEmptyTextFieldOperations() {
        let emptyTextField = UITextField()
        
        XCTAssertEqual(emptyTextField.safeText, "")
        XCTAssertEqual(emptyTextField.trimmedText, "")
        XCTAssertTrue(emptyTextField.isTextEmpty)
        XCTAssertFalse(emptyTextField.isTextNotEmpty)
        XCTAssertEqual(emptyTextField.textLength, 0)
        XCTAssertFalse(emptyTextField.isValidEmail)
        XCTAssertFalse(emptyTextField.isValidChineseMobile)
        XCTAssertFalse(emptyTextField.isValidChineseID)
        XCTAssertFalse(emptyTextField.isNumeric)
        XCTAssertFalse(emptyTextField.isAlphabetic)
        XCTAssertFalse(emptyTextField.isAlphanumeric)
    }
    
    func testWhitespaceTextFieldOperations() {
        textField.text = "   \n\t  "
        
        XCTAssertEqual(textField.trimmedText, "")
        XCTAssertTrue(textField.isTextEmpty)
        XCTAssertFalse(textField.isTextNotEmpty)
        XCTAssertEqual(textField.textLength, 0)
        XCTAssertFalse(textField.isValidEmail)
        XCTAssertFalse(textField.isValidChineseMobile)
        XCTAssertFalse(textField.isNumeric)
    }
    
    // MARK: - 事件处理测试（基础测试）
    
    func testEventHandlersExist() {
        // 测试事件处理方法是否存在
        textField.onEditingChanged { text in
            print("Editing changed: \(text)")
        }
        
        textField.onEditingDidBegin {
            print("Editing began")
        }
        
        textField.onEditingDidEnd {
            print("Editing ended")
        }
        
        textField.onReturn {
            print("Return pressed")
            return true
        }
        
        // 验证目标已添加
        XCTAssertTrue(textField.allTargets.count > 0)
    }
    
    func testTextLengthLimit() {
        var exceededText: String? = nil
        textField.limitTextLength(maxLength: 5) { text in
            exceededText = text
        }
        
        textField.text = "Hello World" // 11个字符
        
        // 由于事件处理可能在主线程，我们直接测试限制逻辑
        textField.sendActions(for: .editingChanged)
        
        // 等待一小段时间让异步处理完成
        let expectation = XCTestExpectation(description: "Wait for text limit")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(textField.text?.count, 5)
        XCTAssertEqual(textField.text, "Hello")
    }
}

#endif