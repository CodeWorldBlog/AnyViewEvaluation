//
//  ContentView.swift
//  AnyViewEvaluation
//
//  Created by Saurav Nagpal on 01/03/24.
//

import SwiftUI

enum EvaluationMode {
    case suspectAnalysisText
    case suspectAnalysisTypeErased
    case crimeSceneNText
    case crimeSceneNTypeErased
    case crimeSceneNTextConditional
    case crimeSceneNTypeErasedConditional
    case crimeSceneHierarychyNTypeErased
    case crimeSceneHierarychyNType
}

class ContentUpdater: ObservableObject {
    private var timer: Timer?
    @Published var isChange: Bool = false
    init() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true
        ) { [weak self] _ in
            self?.isChange.toggle()
        }
    }
}

struct ContentView: View {
    let nTextcount: Int = 2000
    @StateObject private var contentUpdater =  ContentUpdater()
    let textSize: CGSize = CGSize(width: 50, height: 20)
    let mode: EvaluationMode = .crimeSceneHierarychyNType
    
    var body: some View {
        switch mode {
        case .suspectAnalysisText:
            wrapTextInAnyView()
        case .suspectAnalysisTypeErased:
            normalTextWithoutAnyView()
        case .crimeSceneNText:
            nTextInGrid()
        case .crimeSceneNTypeErased:
            nTypeErasedTextInGrid()
        case .crimeSceneNTextConditional:
            conditionNView()
        case .crimeSceneNTypeErasedConditional:
            conditionNViewInAnyView()
        case .crimeSceneHierarychyNType:
            levelHierarchyConditionalView()
        case .crimeSceneHierarychyNTypeErased:
            levelHierarchyTypeErased()
        }
    }
}

#Preview {
    ContentView()
}

// Mark: - Step 1
extension ContentView {
    fileprivate func wrapTextInAnyView() -> AnyView {
        AnyView(VStack {
            Text("Wrap Text In AnyView")
        })
    }
    
    
    fileprivate func normalTextWithoutAnyView() -> VStack<Text> {
        VStack {
            Text("Normal Text")
        }
    }
}

// Mark: - Step 2
extension ContentView {
    @ViewBuilder
    func nTextInGrid() -> some View {
        VStack(spacing: 10) {
            GridView<TextChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
        }
    }
    
    @ViewBuilder
    func nTypeErasedTextInGrid() -> some View {
        VStack(spacing: 10) {
            GridView<TypeErassedTextChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
        }
    }
}


// Mark: - Step 3
extension ContentView {
    @ViewBuilder
    func conditionNViewInAnyView() -> some View {
        VStack(spacing: 10) {
            GridView<ConditionTypeErassedChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
        }
    }
    
    @ViewBuilder
    func conditionNView() -> some View {
        VStack(spacing: 10) {
            GridView<ConditionTextNImageChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
        }
    }
}

// Mark: - Step 3
extension ContentView {
    @ViewBuilder
    func levelHierarchyTypeErased() -> some View {
        ZStack {
            HStack {
                GridView<ConditionTypeErassedChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
            }
        }
    }
    
    @ViewBuilder
    func levelHierarchyConditionalView() -> some View {
        ZStack {
            HStack {
                GridView<ConditionTextNImageChild>(rowCount: 30, columnCount: 7, itemSize: textSize, update: $contentUpdater.isChange)
            }
        }
    }
}

struct TextChild: GridChild {
    var indexPath: IndexPath
    var itemSize: CGSize
    var shouldUpdate: Binding<Bool>
    
    init(indexPath: IndexPath, size: CGSize, shouldUpdate: Binding<Bool>) {
        self.indexPath = indexPath
        self.itemSize = size
        self.shouldUpdate = shouldUpdate
    }
    
    
    var body: some View {
        Text("cell\(indexPath.row)\(indexPath.section)").frame(width: itemSize.width, height: itemSize.height)
    }
}

struct TypeErassedTextChild: GridChild {
    var shouldUpdate: Binding<Bool>
    var indexPath: IndexPath
    var itemSize: CGSize
    
    init(indexPath: IndexPath, size: CGSize, shouldUpdate: Binding<Bool>) {
        self.indexPath = indexPath
        self.itemSize = size
        self.shouldUpdate = shouldUpdate
    }

    var body: some View {
        AnyView(Text("cell\(indexPath.row)\(indexPath.section)").frame(width: itemSize.width, height: itemSize.height))
    }
}


struct ConditionTextNImageChild: GridChild {
    var indexPath: IndexPath
    var itemSize: CGSize
    let shouldUpdate: Binding<Bool>
    
    init(indexPath: IndexPath, size: CGSize, shouldUpdate: Binding<Bool>) {
        self.indexPath = indexPath
        self.itemSize = size
        self.shouldUpdate = shouldUpdate
    }
    
    
    var body: some View {
        if self.shouldUpdate.wrappedValue {
            Text("cell\(indexPath.row)\(indexPath.section)").frame(width: itemSize.width, height: itemSize.height)
        } else {
            Image(systemName: "heart.fill")
        }
    }
}

struct ConditionTypeErassedChild: GridChild {
    var indexPath: IndexPath
    var itemSize: CGSize
    let shouldUpdate: Binding<Bool>
    
    init(indexPath: IndexPath, size: CGSize, shouldUpdate: Binding<Bool>) {
        self.indexPath = indexPath
        self.itemSize = size
        self.shouldUpdate = shouldUpdate
    }
    
    
    var body: some View {
        if self.shouldUpdate.wrappedValue {
            AnyView(Text("cell\(indexPath.row)\(indexPath.section)").frame(width: itemSize.width, height: itemSize.height))
        } else {
            AnyView(Image(systemName: "heart.fill"))
        }
    }
}
