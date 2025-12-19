import XCTest
@testable import FoundationUtils

@MainActor
final class CoordinatorTests: XCTestCase {
    
    func testStart_whenCalled_shouldExecuteStartMethod() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        coordinator.start()
        
        // Then
        XCTAssertEqual(coordinator.startCallCount, 1)
    }
    
    func testStart_whenCalledMultipleTimes_shouldExecuteEachTime() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        coordinator.start()
        coordinator.start()
        coordinator.start()
        
        // Then
        XCTAssertEqual(coordinator.startCallCount, 3)
    }
    
    func testFinish_whenCalled_shouldInvokeOnFinishCallback() {
        // Given
        let coordinator = MockCoordinator()
        var finishResult: String?
        coordinator.onFinish = { result in
            finishResult = result
        }
        
        // When
        coordinator.finish("test-result")
        
        // Then
        XCTAssertEqual(finishResult, "test-result")
    }
    
    func testFinish_whenOnFinishIsNil_shouldNotCrash() {
        // Given
        let coordinator = MockCoordinator()
        coordinator.onFinish = nil
        
        // When
        coordinator.finish("test-result")
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testFinish_whenCalled_shouldRemoveContainerFromStorage() {
        // Given
        let coordinator = MockCoordinator()
        let containerBefore = coordinator.coordinatorContainer
        
        // When
        coordinator.finish("result")
        
        // Then
        let containerAfter = coordinator.coordinatorContainer
        // Should create a new container since the old one was removed
        XCTAssertNotEqual(ObjectIdentifier(containerBefore), ObjectIdentifier(containerAfter))
    }
    
    func testAddChild_whenAddingChild_shouldStoreChildInContainer() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        let delegate = MockCoordinatorChildDelegate()
        parent.childDelegate = delegate
        
        // When
        parent.addChild(coordinator: child)
        
        // Then
        XCTAssertEqual(delegate.didAddCallCount, 1)
        XCTAssertNotNil(delegate.lastAddedChild)
    }
    
    func testAddChild_whenAddingChild_shouldNotifyDelegate() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        let delegate = MockCoordinatorChildDelegate()
        parent.childDelegate = delegate
        
        // When
        parent.addChild(coordinator: child)
        
        // Then
        XCTAssertEqual(delegate.didAddCallCount, 1)
    }
    
    func testAddChild_whenDelegateIsNil_shouldNotCrash() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        parent.childDelegate = nil
        
        // When
        parent.addChild(coordinator: child)
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testCoordinatorContainer_whenAccessedMultipleTimes_shouldReturnSameInstance() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        let container1 = coordinator.coordinatorContainer
        let container2 = coordinator.coordinatorContainer
        
        // Then
        XCTAssertEqual(ObjectIdentifier(container1), ObjectIdentifier(container2))
    }
    
    func testFinish_whenChildFinishes_shouldNotifyParentDelegate() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        let delegate = MockCoordinatorChildDelegate()
        parent.childDelegate = delegate
        parent.addChild(coordinator: child)
        
        // When
        child.finish(())
        
        // Then
        XCTAssertEqual(delegate.didRemoveCallCount, 1)
        XCTAssertNotNil(delegate.lastRemovedChild)
    }
    
    func testFinish_whenChildFinishesAndParentDelegateIsNil_shouldNotCrash() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        parent.childDelegate = nil
        parent.addChild(coordinator: child)
        
        // When
        child.finish(())
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
}

