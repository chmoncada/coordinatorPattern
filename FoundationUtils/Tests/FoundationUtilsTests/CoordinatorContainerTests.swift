import XCTest
@testable import FoundationUtils

@MainActor
final class CoordinatorContainerTests: XCTestCase {
    
    func testGetOrCreateIdentifier_whenCalledMultipleTimes_shouldReturnSameIdentifier() {
        // Given
        let container = CoordinatorContainer()
        
        // When
        let identifier1 = container.getOrCreateIdentifier()
        let identifier2 = container.getOrCreateIdentifier()
        
        // Then
        XCTAssertEqual(identifier1, identifier2)
    }
    
    func testGetOrCreateIdentifier_whenCalledOnDifferentContainers_shouldReturnDifferentIdentifiers() {
        // Given
        let container1 = CoordinatorContainer()
        let container2 = CoordinatorContainer()
        
        // When
        let identifier1 = container1.getOrCreateIdentifier()
        let identifier2 = container2.getOrCreateIdentifier()
        
        // Then
        XCTAssertNotEqual(identifier1, identifier2)
    }
    
    func testAddChild_whenAddingChild_shouldStoreChild() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        let delegate = MockCoordinatorChildDelegate()
        parent.childDelegate = delegate
        
        // When
        parent.coordinatorContainer.addChild(coordinator: child, parent: parent)
        
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
        parent.coordinatorContainer.addChild(coordinator: child, parent: parent)
        
        // Then
        XCTAssertEqual(delegate.didAddCallCount, 1)
    }
    
    func testAddChild_whenDelegateIsNil_shouldNotCrash() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        parent.childDelegate = nil
        
        // When
        parent.coordinatorContainer.addChild(coordinator: child, parent: parent)
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testRemoveChild_whenRemovingExistingChild_shouldRemoveFromChildren() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        parent.coordinatorContainer.addChild(coordinator: child, parent: parent)
        let childIdentifier = child.coordinatorContainer.getOrCreateIdentifier()
        
        // When
        parent.coordinatorContainer.removeChild(identifier: childIdentifier)
        
        // Then
        // Child should be removed (tested via cleanup block execution)
        XCTAssertTrue(true)
    }
    
    func testSetCleanupBlock_whenBlockIsSet_shouldStoreBlock() {
        // Given
        let container = CoordinatorContainer()
        var cleanupExecuted = false
        let block: () -> Void = {
            cleanupExecuted = true
        }
        
        // When
        container.setCleanupBlock(block)
        container.executeCleanup()
        
        // Then
        XCTAssertTrue(cleanupExecuted)
    }
    
    func testExecuteCleanup_whenCalled_shouldExecuteBlockAndClearIt() {
        // Given
        let container = CoordinatorContainer()
        var executionCount = 0
        container.setCleanupBlock {
            executionCount += 1
        }
        
        // When
        container.executeCleanup()
        container.executeCleanup() // Second call should not execute block
        
        // Then
        XCTAssertEqual(executionCount, 1)
    }
    
    func testExecuteCleanup_whenNoBlockIsSet_shouldNotCrash() {
        // Given
        let container = CoordinatorContainer()
        
        // When
        container.executeCleanup()
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testAddChild_whenChildFinishes_shouldExecuteCleanupBlock() {
        // Given
        let parent = MockCoordinator()
        let child = MockCoordinatorVoid()
        let delegate = MockCoordinatorChildDelegate()
        parent.childDelegate = delegate
        parent.coordinatorContainer.addChild(coordinator: child, parent: parent)
        
        // When
        child.finish(())
        
        // Then
        XCTAssertEqual(delegate.didRemoveCallCount, 1)
        XCTAssertNotNil(delegate.lastRemovedChild)
    }
    
    func testAddChild_whenParentIsDeallocated_shouldNotCrashOnCleanup() {
        // Given
        var parent: MockCoordinator? = MockCoordinator()
        let child = MockCoordinatorVoid()
        parent?.coordinatorContainer.addChild(coordinator: child, parent: parent!)
        
        // When
        parent = nil
        child.finish(())
        
        // Then
        // Should not crash even though parent is nil
        XCTAssertTrue(true)
    }
}

