import SwiftUI
import KauMaeCore

struct ProfileSetupView: View {
    @Binding var profile: StyleProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("あなたの条件")
                .font(.headline)

            VStack(spacing: 10) {
                EnumPickerRow(title: "年代", selection: profileBinding(\.ageRange)) { $0.displayName }
                EnumPickerRow(title: "性別", selection: profileBinding(\.gender)) { $0.displayName }
                EnumPickerRow(title: "体型", selection: profileBinding(\.bodyShape)) { $0.displayName }
                EnumPickerRow(title: "肌色", selection: profileBinding(\.skinTone)) { $0.displayName }
                EnumPickerRow(title: "髪型", selection: profileBinding(\.hairStyle)) { $0.displayName }
                EnumPickerRow(title: "目標", selection: profileBinding(\.styleGoal)) { $0.displayName }

                Toggle("メガネあり", isOn: Binding(
                    get: { profile.wearsGlasses },
                    set: { profile = profile.replacing(wearsGlasses: $0) }
                ))
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func profileBinding<Value>(_ keyPath: KeyPath<StyleProfile, Value>) -> Binding<Value> {
        Binding(
            get: { profile[keyPath: keyPath] },
            set: { profile = profile.replacing(keyPath, with: $0) }
        )
    }
}

private extension StyleProfile {
    func replacing<Value>(_ keyPath: KeyPath<StyleProfile, Value>, with value: Value) -> StyleProfile {
        StyleProfile(
            ageRange: keyPath == \StyleProfile.ageRange ? value as! AgeRange : ageRange,
            gender: keyPath == \StyleProfile.gender ? value as! Gender : gender,
            bodyShape: keyPath == \StyleProfile.bodyShape ? value as! BodyShape : bodyShape,
            skinTone: keyPath == \StyleProfile.skinTone ? value as! SkinTone : skinTone,
            hairStyle: keyPath == \StyleProfile.hairStyle ? value as! HairStyle : hairStyle,
            wearsGlasses: wearsGlasses,
            styleGoal: keyPath == \StyleProfile.styleGoal ? value as! StyleGoal : styleGoal
        )
    }

    func replacing(wearsGlasses: Bool) -> StyleProfile {
        StyleProfile(
            ageRange: ageRange,
            gender: gender,
            bodyShape: bodyShape,
            skinTone: skinTone,
            hairStyle: hairStyle,
            wearsGlasses: wearsGlasses,
            styleGoal: styleGoal
        )
    }
}

struct EnumPickerRow<Value: CaseIterable & Hashable>: View where Value.AllCases: RandomAccessCollection {
    let title: String
    @Binding var selection: Value
    let label: (Value) -> String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(Array(Value.allCases), id: \.self) { value in
                    Text(label(value)).tag(value)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
