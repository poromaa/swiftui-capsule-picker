//
//  Created by Joakim Poromaa Helger on 2023-06-18.
//
import SwiftUI

struct CapsulePicker: View {
    @Binding var selectedIndex: Int
    @State private var hoverIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var optionWidth: CGFloat = 0
    @State private var totalSize: CGSize = .zero
    @State private var isDragging: Bool = false
    let titles: [String]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.accentColor)
                .padding(isDragging ? 2 : 0)
                .frame(width: optionWidth, height: totalSize.height)
                .offset(x: dragOffset)
                .gesture(
                    LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .onChanged { value in
                            switch value {
                            case .first(true):
                                isDragging = true
                            case .second(true, let drag):
                                let translationWidth = (drag?.translation.width ?? 0) + CGFloat(selectedIndex) * optionWidth
                                hoverIndex = Int(round(min(max(0, translationWidth), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                            default:
                                isDragging = false
                            }
                        }
                        .onEnded { value in
                            if case .second(true, let drag?) = value {
                                let predictedEndOffset = drag.translation.width + CGFloat(selectedIndex) * optionWidth
                                selectedIndex = Int(round(min(max(0, predictedEndOffset), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                                hoverIndex = selectedIndex
                            }
                            isDragging = false
                        }
                        .simultaneously(with: TapGesture().onEnded { _ in isDragging = false })
                )
            
                .animation(.spring(), value: dragOffset)
                .animation(.spring(), value: isDragging)
            
            Capsule().fill(Color.accentColor).opacity(0.2)
                .padding(-4)
            
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { index in
                    Text(titles[index])
                        .frame(width: optionWidth, height: totalSize.height, alignment: .center)
                        .foregroundColor(hoverIndex == index ? .white : .black)
                        .animation(.easeInOut, value: hoverIndex)
                        .font(.system(size: 14, weight: .bold))
                    
                        .contentShape(Capsule())
                        .onTapGesture {
                            selectedIndex = index
                            hoverIndex = index
                        }.allowsHitTesting(selectedIndex != index)
                }
            }
            .onChange(of: hoverIndex) {i in
                dragOffset =  CGFloat(i) * optionWidth
            }
            .onChange(of: selectedIndex) {i in
                hoverIndex = i
            }
            .frame(width: totalSize.width, alignment: .leading)
        }
        .background(GeometryReader { proxy in Color.clear.onAppear { totalSize = proxy.size } })
        .onChange(of: totalSize) { _ in optionWidth = totalSize.width/CGFloat(titles.count) }
        .onAppear { hoverIndex = selectedIndex }
        .frame(height: 50)
        .padding([.leading, .trailing], 10)
    }
}

struct CapsulePickerPreview: View {
    @State private var selectedIndex = 0
    var titles = ["Red", "Greenas", "Blue"]
    var body: some View {
        VStack {
            CapsulePicker(selectedIndex: $selectedIndex, titles: titles)      .padding()
            Text("Selected index: \(selectedIndex)")
            
            VStack {
                Picker(selection: self.$selectedIndex, label: Text("What is your favorite color?")) {
                    ForEach(titles.indices, id: \.self) { index in
                        Text(self.titles[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                
                
                Text("Value: \(self.titles[self.selectedIndex])")
                Spacer()
            }
        }
        .padding()
    }
}

struct CapsulePicker_Previews: PreviewProvider {
    static var previews: some View {
        CapsulePickerPreview()
    }
}
