package Command 
{
	import Model.Model;
	import util.DI;
	/**
	 * data operation
	 * @author hhg
	 */
	public class DataOperation 
	{
		static public var Num:int = 0;
		
		//math
		public static const sub:int = Num++;
		public static const add:int = Num++;
		public static const multiply:int = Num++;
		public static const divide:int = Num++;
		public static const mod:int = Num++;		
		
		[Inject]
		public var _model:Model;
		
		public function DataOperation()
		{
			
		}
		
		public function  operator(data_name:*,operation:int ,value:*):* 
		{
			var data:* = _model.getValue(data_name);
			switch (operation)
			{
				case sub:
					data -= value;
				break;
				case add:
					data += value;
				break;
				case multiply:
					data *= value;
				break;
				case divide:
					data /= value;
				break;
				case mod:
					data %= value;
				break;			
			}
			
			_model.putValue(data_name,data);
			return data;
		}
		
		//using idx(in _model) to acceess list (in _model) value
		public function  array_idx(data_name:*, idx_name:*):*
		{
			var data:* = _model.getValue(data_name);
			var idx:int = _model.getValue(idx_name);
			
			return data[idx];
		}
		
		//get some DI mapping value
		public function  getMappingValue(data_name:*, mapping_name:*):*
		{
			var Di:DI = _model.getValue(data_name);
			return Di.getValue(mapping_name);
			
		}
	}

}