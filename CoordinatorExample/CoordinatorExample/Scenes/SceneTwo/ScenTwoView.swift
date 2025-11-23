import SwiftUI

struct SceneTwoView: View {

	let viewModel: SceneTwoViewModel

	var body: some View {
		VStack(spacing: 20) {
			HStack {
				Button(action: {
					self.viewModel.notify(.dismiss)
				}) {
					Image(systemName: "chevron.left")
					Text("Back")
				}
				.padding()

				Spacer()
			}

			Spacer()

			Text("Scene Two: Select a value or press back")
				.padding()

			HStack(spacing: 20) {
				Button("One") {
					self.viewModel.notify(.select("One"))
				}
				.buttonStyle(.borderedProminent)

				Button("Two") {
					self.viewModel.notify(.select("Two"))
				}
				.buttonStyle(.borderedProminent)
			}

			Spacer()
		}
		.navigationBarHidden(true)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
