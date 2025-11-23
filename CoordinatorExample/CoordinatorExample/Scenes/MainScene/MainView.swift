import SwiftUI

struct MainView: View {

	let viewModel: MainViewModel

	var body: some View {
		VStack(spacing: 20) {
			Button("Coordinator1") {
				self.viewModel.notify(.showCoordinatorOne)
			}
			.buttonStyle(.borderedProminent)

			Button("Coordinator2") {
				self.viewModel.notify(.showCoordinatorTwo)
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}
