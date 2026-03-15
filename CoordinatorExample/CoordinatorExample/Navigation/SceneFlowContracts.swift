import Foundation

enum SceneFlowRoute: Hashable {
	case sceneOne
	case sceneTwo
}

enum SceneFlowResult: Equatable {
	case dismissed
	case selection(String)
}

enum SceneFlowIntent: Equatable {
	case dismiss
	case select(String)
}
