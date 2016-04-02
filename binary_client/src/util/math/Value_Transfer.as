package util.math 
{
	import flash.display.MovieClip;
	import Model.Model;
	import caurina.transitions.properties.CurveModifiers;
	import Model.valueObject.*;
	
	/**
	 * handle about complicate fomula 
	 * @author hhg4092
	 */
	public class Value_Transfer 
	{
		[Inject]
		public var _model:Model;		
		
		public function Value_Transfer() 
		{
			
		}
		
		public function init():void
		{
			
		}
		
		/**
		 * 拉bar位置計算出相對數值   
		 * @param	pointor   ->拉bar
		 * @param	centrol_point  ->拉bar 起始中心點,一開始在中間就傳 distance /2,在最左邊就傳零 
		 * @param	splite_to  -> 分成幾份
		 * @param	base_unit  -> 最小單位分量 ,設1,每個單位都顥示,設10,每十個單位更新
		 * @return   
		 */
		public function get_continue_amount(pointor:MovieClip , centrol_point:Number = 0 ,dis_splite_to:Number = 100, base_unit:int = 1):int
		{
			var bar_dis_width:Number = 860 - centrol_point ;			
			var num_per_pixel:Number =    dis_splite_to / bar_dis_width ;			
			var amount:int = (pointor.x - centrol_point) * num_per_pixel / base_unit;
			amount = amount * base_unit;
			return amount;
		}
		
	}

}