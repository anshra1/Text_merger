# 🤖 AI Test Writing Partnership Guide
*A comprehensive guide for AI assistants to write and execute Flutter/Dart tests flawlessly*

## 🎯 Purpose
This guide enables AI assistants to write test code that will **always compile and run successfully** on the first try, eliminating the debug-fix-retry cycle that wastes time and effort.

---

## 🚀 Phase 1: Before Writing Any Test Code

### **Step 1: Environment Assessment**
```bash
# Always run these commands first to understand the environment
flutter --version
dart --version
flutter pub get
dart analyze lib/ --fatal-infos
```

### **Step 2: Dependency Analysis**
Before writing tests, check the project's testing dependencies:

```yaml
# Look for these in pubspec.yaml dev_dependencies:
flutter_test: # Always present
test: # For pure Dart tests
mocktail: # Modern mocking (preferred)
mockito: # Legacy mocking
build_runner: # For code generation
```

### **Step 3: Existing Test Pattern Analysis**
```bash
# Find existing test files to understand patterns
find . -name "*_test.dart" -type f
# Read 2-3 existing test files to understand:
# - Import patterns
# - Mock setup patterns  
# - Assertion styles
# - Group/test organization
```

---

## 📝 Phase 2: Writing Test Code (The SAFE Pattern)

### **🔒 SAFE Writing Checklist**
Use this checklist for EVERY test file you write:

#### **S - Setup (Imports & Dependencies)**
```dart
// ✅ ALWAYS include these standard imports
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Import the class under test
import 'package:your_app/path/to/class_under_test.dart';

// ✅ Import all dependency classes for mocking
import 'package:your_app/path/to/dependency_class.dart';
```

#### **A - All Fallback Values (Critical for Modern Mocktail)**
```dart
void main() {
  setUpAll(() {
    // ✅ MANDATORY: Register fallback values for EVERY custom type used in any() calls
    registerFallbackValue(YourCustomType(
      field1: 'default-value',
      field2: 0,
      field3: DateTime.now(),
    ));
    
    // ✅ Register ALL custom types, even simple ones
    registerFallbackValue(AnotherCustomType.empty());
    registerFallbackValue(ThirdCustomType.defaultInstance());
  });
  
  // ... rest of tests
}
```

#### **F - Fully Typed Mocks**
```dart
// ✅ ALWAYS use explicit types in mock calls
when(() => mockService.method(any<String>(), any<CustomType>()))
    .thenAnswer((_) async => expectedResult);

// ✅ ALWAYS use explicit types in verifications
verify(() => mockService.method(any<String>(), any<CustomType>())).called(1);

// ❌ NEVER use bare any() - causes type inference failures
when(() => mockService.method(any(), any()))  // DON'T DO THIS
```

#### **E - Explicit Async Handling**
```dart
// ✅ For async void methods (side effects)
test('should complete operation without throwing', () async {
  expect(() => service.performAction(data), returnsNormally);
});

// ✅ For async methods returning values
test('should return expected result', () async {
  final result = await service.getData();
  expect(result, expectedValue);
});

// ✅ For testing async completion
test('should complete successfully', () async {
  await expectLater(service.performAction(data), completes);
});

// ❌ NEVER test async methods with synchronous expectations
expect(service.performAction(data), isNull);  // DON'T DO THIS
```

---

## 🏗️ Phase 3: Test Structure Templates

### **Template 1: Data Source/Repository Testing**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app/data/your_data_source.dart';
import 'package:your_app/models/your_model.dart';

// Mock classes
class MockDependency extends Mock implements YourDependency {}

void main() {
  setUpAll(() {
    // Register ALL custom types used in any() calls
    registerFallbackValue(YourModel(
      id: 'test-id',
      name: 'test-name',
      createdAt: DateTime.now(),
    ));
  });

  group('YourDataSource', () {
    late MockDependency mockDependency;
    late YourDataSource dataSource;

    setUp(() {
      mockDependency = MockDependency();
      dataSource = YourDataSource(dependency: mockDependency);
    });

    group('methodName()', () {
      group('validation', () {
        test('should throw ValidationException for empty input', () {
          expect(
            () => dataSource.methodName(''),
            throwsA(isA<ValidationException>()),
          );
        });
      });

      group('success cases', () {
        test('should return expected result for valid input', () async {
          // Arrange
          const input = 'valid-input';
          const expectedResult = YourModel(id: 'test', name: 'test');
          when(() => mockDependency.fetch(any<String>()))
              .thenAnswer((_) async => expectedResult);

          // Act
          final result = await dataSource.methodName(input);

          // Assert
          expect(result, expectedResult);
          verify(() => mockDependency.fetch(any<String>())).called(1);
        });
      });

      group('error handling', () {
        test('should wrap dependency errors in DataSourceException', () {
          // Arrange
          when(() => mockDependency.fetch(any<String>()))
              .thenThrow(Exception('Network error'));

          // Act & Assert
          expect(
            () => dataSource.methodName('input'),
            throwsA(isA<DataSourceException>()),
          );
        });
      });
    });
  });
}
```

### **Template 2: Service/Use Case Testing**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app/services/your_service.dart';
import 'package:your_app/models/your_model.dart';

class MockRepository extends Mock implements YourRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(YourModel.empty());
    registerFallbackValue(YourRequest.empty());
  });

  group('YourService', () {
    late MockRepository mockRepository;
    late YourService service;

    setUp(() {
      mockRepository = MockRepository();
      service = YourService(repository: mockRepository);
    });

    test('should process data and return transformed result', () async {
      // Arrange
      final inputData = YourModel(id: '1', value: 'test');
      final expectedOutput = TransformedModel(processedValue: 'PROCESSED_TEST');
      
      when(() => mockRepository.save(any<YourModel>()))
          .thenAnswer((_) async => {});
      when(() => mockRepository.transform(any<YourModel>()))
          .thenAnswer((_) async => expectedOutput);

      // Act
      final result = await service.processData(inputData);

      // Assert
      expect(result, expectedOutput);
      verify(() => mockRepository.save(any<YourModel>())).called(1);
      verify(() => mockRepository.transform(any<YourModel>())).called(1);
    });
  });
}
```

---

## ⚠️ Phase 4: Critical Pitfalls to Avoid

### **❌ Fatal Errors That Will Always Fail:**

#### **1. Missing Fallback Values**
```dart
// ❌ This WILL fail in modern mocktail
test('test without fallback', () {
  when(() => mock.method(any<CustomType>())).thenReturn(result);
  // Error: registerFallbackValue not called for CustomType
});

// ✅ This will always work
setUpAll(() {
  registerFallbackValue(CustomType.empty());
});
```

#### **2. Bare any() Usage**
```dart
// ❌ This causes type inference failures
when(() => mock.put(any(), any())).thenAnswer(...);

// ✅ This is always safe
when(() => mock.put(any<String>(), any<CustomType>())).thenAnswer(...);
```

#### **3. Async/Sync Mismatches**
```dart
// ❌ This will fail - async method returns Future<void>
expect(asyncMethod(), isNull);

// ✅ This handles async correctly
expect(() => asyncMethod(), returnsNormally);
```

#### **4. Import Path Errors**
```dart
// ❌ These cause compilation failures
import 'wrong/path/to/class.dart';
import 'package:nonexistent_package/class.dart';

// ✅ Always verify import paths exist
import 'package:your_app/actual/path/to/class.dart';
```

---

## 🔧 Phase 5: Execution Workflow

### **Pre-Execution Checklist**
Before running any test, verify:

```bash
# 1. Syntax check
dart analyze test/your_test_file.dart

# 2. Dependencies resolved
flutter pub get

# 3. No missing imports
dart analyze --fatal-infos test/your_test_file.dart
```

### **Test Execution Commands**
```bash
# Single test file
flutter test test/path/to/your_test.dart

# With detailed output
flutter test test/path/to/your_test.dart --reporter=json

# Flakiness detection (run 3 times)
for i in {1..3}; do 
  echo "=== RUN $i ==="
  flutter test test/path/to/your_test.dart
done
```

---

## 🎯 Phase 6: AI Writing Strategy

### **For AI Assistants: Step-by-Step Writing Process**

#### **Step 1: Analyze the Class Under Test**
```dart
// Before writing tests, understand:
// 1. What dependencies does it have?
// 2. What custom types are used in method signatures?
// 3. What are the return types (sync/async)?
// 4. What exceptions can it throw?
```

#### **Step 2: Plan Test Structure**
```dart
// Create mental model:
// - How many public methods?
// - How many test scenarios per method?
// - What mock objects are needed?
// - What fallback values are required?
```

#### **Step 3: Write in This Exact Order**
```dart
// 1. Imports (all at once)
// 2. Mock class declarations
// 3. setUpAll() with ALL fallback values
// 4. main() and group() structure
// 5. setUp() with mock instances
// 6. Individual tests with full AAA pattern
```

#### **Step 4: Self-Validation**
```dart
// Before declaring the test complete, verify:
// ✅ Every custom type used in any() has a fallback value
// ✅ Every any() call has explicit type arguments
// ✅ Every async method test uses appropriate expectations
// ✅ All imports are correct and complete
// ✅ No bare any() calls exist
```

---

## 📋 Phase 7: Quality Assurance Templates

### **Method Coverage Template**
For each public method, ensure you have:

```dart
group('methodName()', () {
  group('input validation', () {
    test('should reject null input', () { /* ... */ });
    test('should reject empty input', () { /* ... */ });
    test('should reject invalid format', () { /* ... */ });
  });
  
  group('success scenarios', () {
    test('should handle normal case', () { /* ... */ });
    test('should handle edge case', () { /* ... */ });
    test('should handle boundary conditions', () { /* ... */ });
  });
  
  group('error handling', () {
    test('should handle dependency failures', () { /* ... */ });
    test('should handle network errors', () { /* ... */ });
    test('should handle timeout scenarios', () { /* ... */ });
  });
  
  group('side effects', () {
    test('should call dependencies correctly', () { /* ... */ });
    test('should update state appropriately', () { /* ... */ });
  });
});
```

### **Mock Verification Template**
```dart
// ✅ Always verify mock interactions
test('should call dependency with correct parameters', () async {
  // Arrange
  when(() => mockDep.method(any<String>())).thenAnswer((_) async => result);
  
  // Act
  await serviceUnderTest.performAction('input');
  
  // Assert
  verify(() => mockDep.method('input')).called(1);
  verifyNoMoreInteractions(mockDep);
});
```

---

## 🚨 Emergency Debugging Guide

### **If Tests Fail, Check in This Order:**

#### **1. Compilation Errors**
```bash
dart analyze test/failing_test.dart
# Fix: Missing imports, syntax errors, type errors
```

#### **2. Fallback Value Errors**
```
Error: registerFallbackValue was not previously called
# Fix: Add registerFallbackValue(YourType()) to setUpAll()
```

#### **3. Type Inference Errors**
```
Error: type argument(s) of the function 'any' can't be inferred
# Fix: Change any() to any<SpecificType>()
```

#### **4. Async/Sync Mismatches**
```
Error: Expected null, Actual: Future<void>
# Fix: Use returnsNormally or completes instead of isNull
```

---

## 🎖️ Success Criteria

### **A perfectly written test file will:**
- ✅ Compile without any warnings or errors
- ✅ Run all tests successfully on first execution
- ✅ Have zero flaky tests across multiple runs
- ✅ Cover all public methods with multiple scenarios
- ✅ Use proper mock verification patterns
- ✅ Handle async operations correctly
- ✅ Include comprehensive error testing

### **Time Savings:**
Following this guide eliminates:
- ❌ Debug-fix-retry cycles
- ❌ Type inference troubleshooting
- ❌ Mock setup frustrations
- ❌ Async testing confusion
- ❌ Import resolution issues

---

## 🤝 AI Partnership Success

### **For the AI Writing Tests:**
- Follow the SAFE pattern religiously
- Use the provided templates as starting points
- Verify every checklist item before completion
- Write tests that will pass on first execution

### **For the AI Running Tests:**
- Expect tests to compile and run immediately
- Focus on analyzing results rather than debugging setup
- Generate meaningful reports from successful test runs
- Provide feedback for continuous improvement

---

*This guide ensures seamless AI-to-AI collaboration in test creation and execution, eliminating common pitfalls and enabling focus on test quality rather than technical debugging.*


Based on my comparison, here are the specific lines/concepts from the Testing Rules that are missing or under-covered in the AI Test Writing Guide:

## **Missing Lines/Concepts:**

### **1. File System Testing Specifics:**
```dart
// Missing import for path package
import 'package:path/path.dart' as path;

// Missing path extraction guidance
final name = path.basename(entity.path); // Instead of entity.uri.pathSegments.last

// Missing try/finally pattern emphasis for file system tests
final tempDir = await io.Directory.systemTemp.createTemp('test_prefix');
try {
  // test operations
} finally {
  await tempDir.delete(recursive: true); // ALWAYS cleanup
}
```

### **2. Specific Mock Verification Anti-patterns:**
```dart
// Missing warning about hardcoded keys in verification
// ❌ BAD - Incorrect verification pattern (WILL FAIL)
verify(() => mockBox.put('existing-uuid', any())).called(1);
// ✅ GOOD - Correct capture pattern  
final captured = verify(() => mockBox.put(captureAny(), captureAny())).captured;
```

### **3. Error Message Testing Process:**
```dart
// Missing the "Test First, Then Update Expectations" workflow
// CRITICAL PROCESS:
// 1. Write test with best guess expectation
// 2. Run test and observe actual error message  
// 3. Update expectation to match implementation
// 4. Re-run to confirm test passes
```

### **4. Test Naming and Documentation:**
```dart
// Missing specific guidance on descriptive test names
test('should update existing entry timestamp when saving workspace to recent history', () {});
test('should throw ValidationException when path is empty string', () {});
test('should handle storage errors gracefully and wrap in StorageException', () {});
```

### **5. Resource Cleanup Patterns:**
```dart
// Missing explicit try/finally resource management
test('test with resources', () async {
  final tempDir = await io.Directory.systemTemp.createTemp('test');
  final subscription = stream.listen(handler);
  try {
    // Test logic here
  } finally {
    // ALWAYS cleanup - even if test fails
    await tempDir.delete(recursive: true);
    await subscription.cancel();
  }
});
```

### **6. Bracket Verification for Commented Code:**
```dart
// Missing guidance on checking for orphaned braces in large commented sections
// Critical Rule: When commenting out large test sections, use IDE bracket matching to verify structure integrity.
```
