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
    
    
    func scalarMultiplication(scalar: Float64) -> Matrix {
        
        var product:[[Float64]] = []
        
        for row in self.data {
            var resultRow:[Float64] = []
            for element in row {
                resultRow.append(element*scalar)
            }
            product.append(resultRow)
        }
        return Matrix(data: product)
    }
    
    
    private func calculatedTransposed(data: [[Float64]]) -> Matrix {
        var transposedMatrix:[[Float64]] = []
        for col in 0...(data[0].count - 1) {
            var newRow:[Float64] = []
            for row in data {
                newRow.append(row[col])
            }
            transposedMatrix.append(newRow)
        }
        return Matrix(data: transposedMatrix)
    }
    
    
    func transpose() -> Matrix {
        return calculatedTransposed(data: self.data)
    }
    
    
    private func calculateDeterminat(data: [[Float64]]) -> Float64 {
        
        var determinant:Float64 = 0
        if data[0].count > 1 {
            
            // Recursively call function and use Laplace rule
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
    
    
    private func subMatrix(data: [[Float64]], withoutRow: Int, withoutCol: Int) -> [[Float64]] {
        // Helper function to get a sub matrix of a matrix, e.g. for calculating the
        // sub determinants for a cofactor matrix.
        var subMatrix: [[Float64]] = []
        
        var truncatedMatrix:[[Float64]] = data
        truncatedMatrix.remove(at: withoutRow)
        
        for row in 0...(truncatedMatrix.count - 1){
            var subRow:[Float64] = truncatedMatrix[row]
            subRow.remove(at: withoutCol)
            subMatrix.append(subRow)
        }
        
        return subMatrix
    }
    
    
    
    private func calculateCofactorMatrix(data: [[Float64]]) -> Matrix {
        var cofactorMatrix:[[Float64]] = []
        
        // Loop over all coefficient, get right sign,
        // and determinant of sub matrix.
        
        // Note that this function is only allowed for aquare matrices.
        let rows:Int = data[0].count
        let cols:Int = rows
        
        for row in 0...(rows - 1) {
            var tempRow:[Float64] = []
            for col in 0...(cols - 1) {
                let det:Float64 = calculateDeterminat(data: subMatrix(data: data, withoutRow: row, withoutCol: col))
                let sign:Float64 = pow((0-1), (Float64(row) + Float64(col)))
                tempRow.append(sign*det)
            }
            cofactorMatrix.append(tempRow)
        }
        
        return Matrix(data: cofactorMatrix)
    }
    
    
    func cofactorMatrix() -> Matrix {
        return calculateCofactorMatrix(data: self.data)
    }
    
    
    private func calculateAdjoint(data: [[Float64]]) -> Matrix {
        return calculateCofactorMatrix(data: data).transpose()
    }
    
    
    func adjoint() -> Matrix {
        return calculateAdjoint(data: self.data)
    }
    
    
    private func calculateInverse(data: [[Float64]]) -> Matrix {
        // This function uses the adjoint approach, which is
        // invserse(A) = 1/det(A)*adjoint(A)
        return calculateAdjoint(data: self.data).scalarMultiplication(scalar: 1/calculateDeterminat(data: self.data))
    }
       
    
    func inverse() -> Matrix {
        return calculateInverse(data: self.data)
    }
    
    
}



//let test:Matrix = Matrix(data: [[2, 4], [-1, 3]])
//let test:Matrix = Matrix(data: [[2, 4, 3], [-1, 3, 2], [0, 1, 2]])
//print(test.inverse())
