package View.ViewBase 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * Dynamic_text (for mandarin font)
	 * @author Dyson0913
	 */
	public class Visual_Text  extends VisualHandler
	{
		public var align_left:String = TextFormatAlign.LEFT;
		public var align_center:String = TextFormatAlign.CENTER;
		public var align_right:String = TextFormatAlign.RIGHT
		
		public function Visual_Text() 
		{
			
		}
		
		public function init():void
		{			
			
		}
		
		public function textSetting_s(mc:MovieClip, data:Array):void
		{						
			var str:TextField = dynamic_text(data[1], data[0]);
			str.name = "Dy_Text";
			mc.addChild(str);
		}
		
		public function textSetting(mc:MovieClip, idx:int, data:Array):void
		{	
			var s:String; 
			if ( data[idx + 1] == undefined) s = "";
			else s =  data[idx + 1];
			
			var str:TextField = dynamic_text(s, data[0]);			
			str.name = "Dy_Text";
			mc.addChild(str);
		}
		
		public function text_update(mc:MovieClip, idx:int, data:Array):void
		{
			var Text:TextField = mc.getChildByName("Dy_Text") as TextField;
			Text.text = data[idx];
		}
		
		public function colortextSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			var textColor:uint = 0xFFFFFF;
			if ( parseInt( data[idx + 1]) > 0) textColor = 0x00FF33;
			
			var ob:Object = data[0];
			ob["color"] = textColor;
			var str:TextField = dynamic_text(data[idx + 1], ob);
			
			mc.addChild(str);
		}
		
		public function color_update(mc:MovieClip, idx:int, data:Array):void
		{
			var Text:TextField = mc.getChildByName("Dy_Text") as TextField;			
			Text.textColor = data[idx];			
		}
		
		public function dynamic_text(text:String,para:Object):TextField
		{		
			//utilFun.Log("para ="+para.size);
			var size:int = para.size;
			var textColor:uint = 0xFFFFFF;
			var align:String = TextFormatAlign.LEFT;
			var bold:Boolean = false;
			
			if ( para["color"] != undefined)  textColor = para.color;
			if( para["align"] != undefined)  align = para.align;
			if( para["bold"] != undefined)  bold = para.bold;
			
			var _NickName:TextField = new TextField();			
			_NickName.width = 200;
			_NickName.height = 50;
			_NickName.textColor = textColor;
			_NickName.selectable = false;	
			//_NickName.opaqueBackground = 0x999999;
			//_NickName.autoSize = TextFieldAutoSize.LEFT;				
			//_NickName.wordWrap = true; //auto change line
			//_NickName.multiline = true; //multi line
			_NickName.maxChars = 300;
			//"微軟正黑體"
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = align;
			myFormat.bold = bold;
			myFormat.font = "Microsoft JhengHei";			
			
			_NickName.defaultTextFormat = myFormat;				
			_NickName.text = text;
			return _NickName;
		}
		
	}

}