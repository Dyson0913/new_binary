package View.Viewutil 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import Interface.ViewComponentInterface;
	import View.Viewutil.AdjustTool;
	
	import View.ViewBase.*;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	
	/**
	 * replay package present way
	 * @author Dyson0913
	 */
	public class Visual_package_replayer extends VisualHandler
	{
		[Inject]
		public var _MsgModel:MsgQueue;
		
		private var _packlist:Array = [];
		private var _pack_idx:int = 0;
		
		public function Visual_package_replayer() 
		{
			
		}
		
		public function init():void
		{
			//var sim_pack:MultiObject = create("sim_pack", [ResName.TextInfo]);	
			
			var data:Array = ["<<", "->", ">>", "frame:"];
			var font2:Array = [{ size:18 } ];
			font2 = font2.concat(data);		
			var script_list:MultiObject = create("replay_interface", [ResName.TextInfo]);	
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = interface_click;
			script_list.CustomizedData = font2;
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [data.length, 50, 100];	
			script_list.Create_(data.length);	
			script_list.container.x = 600;
			
			_packlist.length = 0;
			_pack_idx = 0;
		}
		
		//[MessageHandler(type="Model.valueObject.ArrayObject",selector="replay_config_complete")]		
		public function lsit(replayinfo:ArrayObject):void
		{	
			//確認為自己要求的mission
				//utilFun.Log("replayinfo.Value[0]"+replayinfo.Value[0]);
				//utilFun.Log("mission_id()"+mission_id());
			if ( replayinfo.Value[0] != mission_id()) return;
			
		}	
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="replay_pack")]		
		public function set_data(replayinfo:ArrayObject):void
		{
			init();
			
			_packlist = replayinfo.Value;
		}
		
		public function interface_click(e:Event, idx:int):Boolean
		{
			GetSingleItem("replay_interface", 3).getChildByName("Dy_Text").text = "frame:" + _pack_idx.toString();
			play_frame()
			
			
			if ( idx == 0) _pack_idx = Math.min(0, _pack_idx -1);
			if ( idx == 1 || idx == 2) 
			{
				_pack_idx += 1;				
				_pack_idx %= _packlist.length;	
			}		
			
			
			
			return true;
		}
		
		public function play_frame():void
		{
			var fakePacket:Object  = _packlist[_pack_idx]; 
			
			_MsgModel.push(fakePacket);			
		
		}
		
	}

}