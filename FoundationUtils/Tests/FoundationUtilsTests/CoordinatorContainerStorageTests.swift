import XCTest
@testable import FoundationUtils

@MainActor
final class CoordinatorContainerStorageTests: XCTestCase {
    
    func testGetOrCreateContainer_whenCalledFirstTime_shouldCreateNewContainer() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        let container = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        
        // Then
        XCTAssertNotNil(container)
    }
    
    func testGetOrCreateContainer_whenCalledMultipleTimes_shouldReturnSameContainer() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        let container1 = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        let container2 = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        
        // Then
        XCTAssertEqual(ObjectIdentifier(container1), ObjectIdentifier(container2))
    }
    
    func testGetOrCreateContainer_whenCalledForDifferentCoordinators_shouldReturnDifferentContainers() {
        // Given
        let coordinator1 = MockCoordinator()
        let coordinator2 = MockCoordinator()
        
        // When
        let container1 = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator1)
        let container2 = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator2)
        
        // Then
        XCTAssertNotEqual(ObjectIdentifier(container1), ObjectIdentifier(container2))
    }
    
    func testRemoveContainer_whenContainerExists_shouldRemoveFromStorage() {
        // Given
        let coordinator = MockCoordinator()
        let containerBefore = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        
        // When
        CoordinatorContainerStorage.removeContainer(for: coordinator)
        let containerAfter = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        
        // Then
        XCTAssertNotEqual(ObjectIdentifier(containerBefore), ObjectIdentifier(containerAfter))
    }
    
    func testRemoveContainer_whenContainerDoesNotExist_shouldNotCrash() {
        // Given
        let coordinator = MockCoordinator()
        
        // When
        CoordinatorContainerStorage.removeContainer(for: coordinator)
        
        // Then
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testGetOrCreateContainer_whenRemovedAndRecreated_shouldCreateNewContainer() {
        // Given
        let coordinator = MockCoordinator()
        let originalContainer = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        CoordinatorContainerStorage.removeContainer(for: coordinator)
        
        // When
        let newContainer = CoordinatorContainerStorage.getOrCreateContainer(for: coordinator)
        
        // Then
        XCTAssertNotEqual(ObjectIdentifier(originalContainer), ObjectIdentifier(newContainer))
    }
}

