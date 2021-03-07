//
//  Matrix.swift
//  MLbySascha
//
//  Created by Sascha Rexhäuser on 23.02.21.
//

import Foundation

struct Matrix {
    
    let data:[[Float64]]
    let rows:Int
    let columns:Int
    let isSymmetric:Bool
    
    init(data:[[Float64]]){
        self.data = data
        self.rows = self.data.count
        self.columns = self.data[0].count
        if self.rows != self.columns {
            self.isSymmetric = false
        } else {
            self.isSymmetric = true
        }
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
    
    enum MathematicalError: Error {
        case inverseDoesNotExist
        case multiplicationNotPossible(String)
    }
    
    private func calculateInverse(data: [[Float64]]) throws -> Matrix {
        // This function uses the adjoint approach, which is
        // invserse(A) = 1/det(A)*adjoint(A)
        
        let det:Float64 = calculateDeterminat(data: self.data)
        
        // matrices with determinant of 0 are not invertible:
        if det == 0 {
            throw MathematicalError.inverseDoesNotExist
        }

        return calculateAdjoint(data: self.data).scalarMultiplication(scalar: 1/det)
    }
       
    
    func inverse() -> Matrix {
        do {
            return try calculateInverse(data: self.data)
        } catch MathematicalError.inverseDoesNotExist {
            print("This matrix has no inverse!")
            return Matrix(data: [[]])
        } catch {
            print("Ooops, an unknown error occured. Enjoy debugging ;-)")
            return Matrix(data: [[]])
        }
        
    }
    
        
    
    func multiply(with: Matrix) -> Matrix {
        
        var newArray:[[Float64]] = []
        if (self.rows != with.columns) && (self.columns != with.rows) {
            print("Multiplication not possible. Ensure you multiply a n x m matrix with an m x n matrix. An empty Matrix is returned")
        } else {
            for i in 0...(self.data.count - 1)  {
                var newRow:[Float64] = []
                for k in 0...(with.data[i].count - 1){
                    var newCoef:Float64 = 0
                    for j in 0...(self.data[i].count - 1) {
                        newCoef = newCoef + self.data[i][j]*with.data[j][k]
                    }
                    newRow.append(newCoef)
                }
                newArray.append(newRow)
            }
        }
        return Matrix(data: newArray)
    }
}

//let test:Matrix = Matrix(data: [[2, 4], [-1, 3]])
//let test:Matrix = Matrix(data: [[2, 2], [2, 2]])
//let test:Matrix = Matrix(data: [[2, 4, 3], [-1, 3, 2], [0, 1, 2]])
//print(test.inverse())

//let A:Matrix = Matrix(data: [[3, 2, 1], [1, 0, 2]])
//let B:Matrix = Matrix(data: [[1, 2], [0, 1], [4, 0]])
//print(A.multiply(with: B))

// Simple linear regression:
//let X:Matrix = Matrix(data: [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10]])
//let y:Matrix = Matrix(data: [[1.6], [2.1], [2.4], [2.9], [2.9], [3.5], [4.1], [4.7], [4.8], [5.6]])
//print(X.transpose().multiply(with: X).inverse().multiply(with: X.transpose()).multiply(with: y))
