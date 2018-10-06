package com.mathematics 
{
	/**
	 * ...
	 * @author ...
	 */
	public class IonMath 
	{
		const H:String = "H";
		const X:String = "X";
		const C:String = "C";
		const I:String = " ";
		
		public var _hGate:Array;
		public var _xGate:Array;
		public var _iGate:Array;
		public var _CXOperate:Array;
		public var _XCOperate:Array;
		
		public function IonMath() 
		{
			//H Gate
			var h1:Array = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
			var h2:Array = [1 / Math.sqrt(2), -1 / Math.sqrt(2)];
			_hGate = [h1, h2];
			
			//X Gate
			var x1:Array = [0, 1];
			var x2:Array = [1, 0];
			_xGate = [x1, x2];
			
			//I gate
			var i1:Array = [1, 0];
			var i2:Array = [0, 1];
			_iGate = [i1, i2];
			
			//CX
			var cx1:Array = [1, 0, 0, 0];
			var cx2:Array = [0, 1, 0, 0];
			var cx3:Array = [0, 0, 0, 1];
			var cx4:Array = [0, 0, 1, 0];
			_CXOperate = [cx1, cx2, cx3, cx4];
			
			//XC
			var xc1:Array = [1, 0, 0, 0];
			var xc2:Array = [0, 0, 0, 1];
			var xc3:Array = [0, 0, 1, 0];
			var xc4:Array = [0, 1, 0, 0];
			_XCOperate = [xc1, xc2, xc3, xc4];
		}
		
		public function CalcaGroup(savedResult:Array,oper1:String, oper2:String):Array
		{
			//trace("group to calc:" + savedResult+","  + oper1+"," + oper2);
			var oper1Matrix:Array;
			var oper2Matrix:Array;
			var operResult:Array;
			var result:Array;
			
			//No C oper
			if (oper1 != C && oper2 != C)
			{
				oper1Matrix = OperMatrix(oper1);
				oper2Matrix = OperMatrix(oper2);
				operResult = KroneckerMatrixOperate(oper1Matrix, oper2Matrix);
				result = MatrixVectrorOperate(operResult, savedResult);
			}
			else
			{
				if (oper1 == C)
				{
					if (oper2 != X)
					{
						result = savedResult;
					}
					else//CX
					{
						result = MatrixVectrorOperate(_CXOperate, savedResult);
					}
				}
				else if (oper2 == C)
				{
					if (oper1 != X)
					{
						result = savedResult;
					}
					else//XC
					{
						result = MatrixVectrorOperate(_XCOperate, savedResult);
					}
				}
			}
			return result;
		}
		
		public function CalcSecurity(savedResult:Array,oper1:String, oper2:String):Array
		{
			//trace("group to calc:" + savedResult+","  + oper1+"," + oper2);
			var oper1Matrix:Array;
			var oper2Matrix:Array;
			var operResult:Array;
			var result:Array;
			
			//No C oper
			if (oper1 != C && oper2 != C)
			{
				oper1Matrix = OperMatrix(oper1);
				oper2Matrix = OperMatrix(oper2);
				operResult = KroneckerMatrixOperate(oper1Matrix, oper2Matrix);
				if (savedResult!= null)
				{
					result = MatrixxMatrix(savedResult,operResult);
				}
				else
				{
					result = operResult;
				}
			}
			else
			{
				if (oper1 == C)
				{
					if (oper2 != X)
					{
						result = savedResult;
					}
					else//CX
					{
						if (savedResult != null)
						{
							result = MatrixxMatrix(savedResult, _CXOperate);
						}
						else
						{
							result = _CXOperate;
						}
					}
				}
				else if (oper2 == C)
				{
					if (oper1 != X)
					{
						result = savedResult;
					}
					else//XC
					{
						if (savedResult != null)
						{
							result = MatrixxMatrix(savedResult, _XCOperate);
						}
						else
						{
							result = _XCOperate;
						}
					}
				}
			}
			return result;
		}
		
		function OperMatrix(operSymbol:String):Array 
		{
			var result:Array = new Array();
			switch(operSymbol)
			{
				case H:
					result = _hGate;
					break;
				case X:
					result = _xGate;
					break;
				case I:
					result = _iGate;
					break;
			}
			return result;
		}
		
		
		/*---------------------------------------base math--------------------------------------------*/
		function MatrixVectrorOperate(matrix:Array,vector:Array):Array 
		{
			var result:Array;
			var dimension:int = matrix.length;
			if (dimension != vector.length||dimension!=2&&dimension!=4)
			{
				trace("向量矩阵运算错误");
			}
			
			var result1:Number;
			var result2:Number;
			var result3:Number;
			var result4:Number;
			if (dimension == 2)
			{
				result1 = matrix[0][0] * vector[0] + matrix[0][1] * vector[1];
				//trace(result1);
				result2 = matrix[1][0] * vector[0] + matrix[1][1] * vector[1];
				//trace(result2);
				result = [result1,result2];
			}
			else//dimension==4
			{
				result1 = matrix[0][0] * vector[0] + matrix[0][1] * vector[1]+matrix[0][2] * vector[2] + matrix[0][3] * vector[3];
				result2 = matrix[1][0] * vector[0] + matrix[1][1] * vector[1]+matrix[1][2] * vector[2] + matrix[1][3] * vector[3];
				result3 = matrix[2][0] * vector[0] + matrix[2][1] * vector[1]+matrix[2][2] * vector[2] + matrix[2][3] * vector[3];
				result4 = matrix[3][0] * vector[0]+matrix[3][1]*vector[1]+matrix[3][2]*vector[2]+matrix[3][3]*vector[3];
				result = [result1, result2, result3, result4];
			}
			return result;
			
		}
		
		function KroneckerVecutorOperate(vector1:Array, vector2:Array):Array
		{
			if (vector1.length != 2 || vector1.length != vector2.length)
			{
				trace("向量克罗内克积运算错误");
				return new Array();
			}
			else
			{
				var result1 = vector1[0] * vector2[0];
				var result2 = vector1[0] * vector2[1];
				var result3 = vector1[1] * vector2[0];
				var result4 = vector1[1] * vector2[1];
				var result:Array = [result1, result2, result3, result4];
				return result;
			}
		}
		
		public function KroneckerMatrixOperate(matrix1:Array, matrix2:Array):Array
		{
			if (matrix1.length != 2 || matrix1.length != matrix2.length)
			{
				trace("矩阵克罗内克积运算错误");
				return new Array();
			}
			else
			{
				var result1:Array = [matrix1[0][0] * matrix2[0][0], matrix1[0][0] * matrix2[0][1], matrix1[0][1] * matrix2[0][0], matrix1[0][1] * matrix2[0][1]];
				var result2:Array = [matrix1[0][0] * matrix2[1][0], matrix1[0][0] * matrix2[1][1], matrix1[0][1] * matrix2[1][0], matrix1[0][1] * matrix2[1][1]];
				var result3:Array = [matrix1[1][0] * matrix2[0][0], matrix1[1][0] * matrix2[0][1], matrix1[1][1] * matrix2[0][0], matrix1[1][1] * matrix2[0][1]];
				var result4:Array = [matrix1[1][0] * matrix2[1][0], matrix1[1][0] * matrix2[1][1], matrix1[1][1] * matrix2[1][0], matrix1[1][1] * matrix2[1][1]];
				var result:Array = [result1, result2, result3, result4];
				return result;
			}
		}
		
		public function MatrixxMatrix(matrix1:Array, matrix2:Array):Array
		{
			//trace(matrix1 +"============"+ matrix2);
			var result:Array = new Array();
			if (matrix1.length != matrix2.length)
			{
				trace("矩阵*矩阵运算错误");
				return null;
			}
			else
			{
				var dimension:int = matrix1.length;
				if (dimension != 4)
				{
					trace("暂不支持非4*4矩阵*矩阵运算");
					return null;
				}
				
				var m1Value:Number;
				var m2Value:Number;
				var rowArray:Array;
				
				for (var rowIndex:int = 0; rowIndex <dimension ; rowIndex++) 
				{
					rowArray = new Array();
					for (var colIndex:int = 0; colIndex <dimension ; colIndex++) 
					{
						var rowValue:Number = 0;
						for (var calcIndex:int = 0; calcIndex < dimension; calcIndex++) 
						{
							m1Value = matrix1[rowIndex][calcIndex];
							m2Value = matrix2[calcIndex][colIndex];
							//trace(m1Value +"============"+ m2Value);
							rowValue+= Math.round(m1Value * m2Value * 10) / 10;
						}
						rowArray.push(rowValue);
						//trace("push value:" + rowValue);
					}
					result.push(rowArray);
					//trace("push array:" + rowArray);
				}
				return result;
			}
		}
		
	}

}