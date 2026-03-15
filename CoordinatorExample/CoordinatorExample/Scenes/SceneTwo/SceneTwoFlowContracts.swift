import Foundation

enum SceneTwoFlowRoute: Hashable {
	case sceneTwoDetails
}

enum SceneTwoFlowResult: Equatable {
	case dismissed
	case selection(String)
}

enum SceneTwoFlowIntent: Equatable {
	case dismiss
	case select(String)
}
