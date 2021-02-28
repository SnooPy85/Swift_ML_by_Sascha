//
//  Matrix.swift
//  MLbySascha
//
//  Created by Sascha Rexhäuser on 23.02.21.
//

import Foundation


struct Matrix {
    
    var data:[[Float64]]
    
    init(data:[[Float64]]){
        self.data = data
    }
    
    func transpose() -> Matrix {
        var transposedMatrix:[[Float64]] = []
        for col in 0...(self.data[0].count - 1) {
            var newRow:[Float64] = []
            for row in self.data {
                newRow.append(row[col])
            }
            transposedMatrix.append(newRow)
        }
        return Matrix(data: transposedMatrix)
    }
    
    
    private func calculateDeterminat(data: [[Float64]]) -> Float64 {
        
        // To-Do: add check whether matrix is symmetric!
        
        var determinant:Float64 = 0
        if data[0].count > 1 {
            
            // Recursively call function itself and use Laplace rule
            // ... and always develop for first row:
            var truncatedMatrix:[[Float64]] = data
            truncatedMatrix.remove(at: 0)
    
            var sign:Int = 1
            for ColNumber in 0...(data[0].count - 1) {
                var subMatrix:[[Float64]] = []
                for rowNumber in 0...(truncatedMatrix.count - 1) {
                    var subRow:[Float64] = truncatedMatrix[rowNumber]
                    subRow.remove(at: Int(ColNumber))
                    subMatrix.append(subRow)
                }
                // Update determinat:
                determinant = determinant + Float64(sign)*data[0][Int(ColNumber)]*calculateDeterminat(data: subMatrix)
                sign = sign*(0-1)
            }
            
        } else {
            // (Final) case of 1x1 matrix.
            determinant = data[0][0]
        }
        
        return determinant
    }
    
    
    func determinant() -> Float64 {
        return calculateDeterminat(data: self.data)
    }
    
    
    func adjoint() -> Matrix {
        
        var adjoint:[[Float64]] = []
        
        return Matrix(data: adjoint)
    }
    
    
    func inverse() -> Matrix {
        var inversedMatrix:[[Float64]] = []
        
        return Matrix(data: inversedMatrix)
    }
    
    
}



//let test:Matrix = Matrix(data: [[2, 4], [-1, 3]])
//print(test.determinant())

//let test2:Matrix = Matrix(data: [[2, 4, 3], [-1, 3, 2], [0, 1, 2]])
//print(test2.determinant())
