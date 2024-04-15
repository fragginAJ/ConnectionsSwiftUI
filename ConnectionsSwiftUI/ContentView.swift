//
//  ContentView.swift
//  ConnectionsSwiftUI
//
//  Created by AJ Fragoso on 4/14/24.
//

import SwiftUI

struct ContentView: View {
    @State var size: CGSize?
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    private let spacing: CGFloat = 10
    private let itemLabelInset: CGFloat = 5
    
    var body: some View {
        NavigationStack {
            Spacer()
                .frame(height: 1)
            
            Divider()
                .background(Color.gray)
            
            header
            
            GeometryReader { geometry in
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<16, id: \.self) { index in
                        Button(action: {
                            // Handle the button tap
                            print("Button \(index) tapped")
                        }) {
                            Text("\(index + 1): word")
                                .padding(.horizontal, itemLabelInset)
                                .frame(
                                    minWidth: buttonSize(geometryWidth: geometry.size.width),
                                    maxWidth: .infinity,
                                    minHeight: buttonSize(geometryWidth: geometry.size.width),
                                    maxHeight: buttonSize(geometryWidth: geometry.size.width)
                                )
                                .unselected()
                        }
                    }
                }
                .padding(.horizontal, spacing)
                .toolbar {
                    toolbarButtons
                }
            }
            .frame(height: calculateGridHeight(geometryWidth: UIScreen.main.bounds.width))
            
            mistakeCounter
                .padding(15)
            
            gameButtons
            
            Spacer()
        }
    }
    
    private var header: some View {
        Text("Create four groups of four!")
            .padding(.vertical, 20.0)
    }
    
    private var mistakeCounter: some View {
        HStack {
            Text("Mistakes remaining:")
            ForEach(0..<4, id: \.self) { index in
                Image(systemName: "circle.fill")
                    .foregroundStyle(MistakeIconStyle())
            }
        }
    }
    
    private var gameButtons: some View {
        HStack(spacing: 12) {
            pillButton("Shuffle", isActive: true) {
                print("Pressed")
            }
            
            pillButton("Deselect all", isActive: false) {
                print("Pressed")
            }
            
            pillButton("Submit", isActive: false) {
                print("Pressed")
            }
        }
    }
    
    private var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                print("Pressed")
            } label: {
                Image(systemName: "gearshape.fill")
                    .tint(.black)
            }
            
            Button {
                print("Pressed")
            } label: {
                Image(systemName: "questionmark.circle.fill")
                    .tint(.black)
            }
        }
    }
    
    private func pillButton(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(isActive ? .black : .gray)
                .font(Font.system(size: 14, weight: .medium))
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
        }
        .background(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
            .stroke(isActive ? .black : .gray, lineWidth: 0.5)
        )
    }
    
    /// Calculates the size of each button based on the available width and desired spacing
    /// - Parameter geometryWidth: A measure of the containing view's width
    /// - Returns: The size needed to lay out a grid of squared buttons
    private func buttonSize(geometryWidth: CGFloat) -> CGFloat {
        let width = geometryWidth - (spacing * 5)  // account for padding and spacing
        return width / 4  // divide by the number of columns
    }
    
    func calculateGridHeight(geometryWidth: CGFloat) -> CGFloat {
        let buttonWidth = (geometryWidth - (spacing * 5)) / 4
        return buttonWidth * 4 + spacing * 3  // Total height for 4 rows plus spacing
    }
}

struct UnselectedItemButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .font(.headline)
            .minimumScaleFactor(0.25)
            .foregroundColor(.black)
            .background(Color.idleDust)
            .cornerRadius(5)
    }
}

struct SelectedItemButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.activatedCharcoal)
            .cornerRadius(5)
    }
}

struct MistakeIconStyle: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color.activatedCharcoal.blendMode(.normal)
    }
}

// Custom modifiers
extension View {
    
    /// Sandy colored button for an inactive item
    /// - Returns: The `View` with the styling of an unselected item
    func unselected() -> some View {
        modifier(UnselectedItemButton())
    }
    
    /// Dark colored button for an active item
    /// - Returns: The `View` with the styling of an selected item
    func selected() -> some View {
        modifier(SelectedItemButton())
    }
}

extension Color {
    static let idleDust: Color = .init(red: 239.0/255.0,
                                       green: 239.0/255.0,
                                       blue: 231.0/255.0)
    
    static let activatedCharcoal: Color = .init(red: 90.0/255.0,
                                           green: 89.0/255.0,
                                           blue: 79.0/255.0)
}

#Preview {
    ContentView()
}
