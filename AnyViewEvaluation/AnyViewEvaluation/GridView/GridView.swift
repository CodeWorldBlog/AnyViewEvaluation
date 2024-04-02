//
//  GridView.swift
//  AnyViewEvaluation
//
//  Created by Saurav Nagpal on 28/03/24.
//

import SwiftUI

protocol GridChild: View {
    var indexPath: IndexPath { get }
    var itemSize: CGSize { get }
    var shouldUpdate: Binding<Bool> { get }
    
    init(indexPath: IndexPath, size: CGSize, shouldUpdate: Binding<Bool>)
}

struct GridView<cell: GridChild>: View {
    var rowCount: Int
    var columnCount: Int
    var itemSize: CGSize
    let update: Binding<Bool>
    
    var body: some View {
        return GeometryReader { proxy in
            ZStack {
                Grid {
                    ForEach((1...rowCount), id: \.self) { rowNumber in
                        self.gridRow(rowNumber: rowNumber)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func gridRow(rowNumber: Int) -> some View {
        GridRow {
            ForEach((1...columnCount), id: \.self) { columnNumber in
                let indexPath = IndexPath(row: rowNumber, section: columnNumber)
                cell(indexPath: indexPath, size: self.itemSize, shouldUpdate: self.update)
            }
        }
    }
}



