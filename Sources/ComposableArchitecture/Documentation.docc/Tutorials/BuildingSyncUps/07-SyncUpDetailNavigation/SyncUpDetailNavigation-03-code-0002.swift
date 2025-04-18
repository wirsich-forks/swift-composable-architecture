import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpsList {
  // ...
}

struct SyncUpsListView: View {
  @Bindable var store: StoreOf<SyncUpsList>

  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        NavigationLink(
          state: AppFeature.Path.State.detail(SyncUpDetail.State(syncUp: <#Shared<SyncUp>#>))
        ) {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
    }
    .sheet(item: $store.scope(state: \.addSyncUp, action: \.addSyncUp)) { addSyncUpStore in
      NavigationStack {
        SyncUpFormView(store: addSyncUpStore)
          .navigationTitle("New sync-up")
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Discard") {
                store.send(.discardButtonTapped)
              }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Add") {
                store.send(.confirmAddButtonTapped)
              }
            }
          }
      }
    }
    .toolbar {
      Button {
        store.send(.addSyncUpButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
  }
}

struct CardView: View {
  let syncUp: SyncUp

  var body: some View {
    VStack(alignment: .leading) {
      Text(syncUp.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(syncUp.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(syncUp.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundStyle(syncUp.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsList.State(
          syncUps: [.mock]
        )
      ) {
        SyncUpsList()
      }
    )
  }
}
