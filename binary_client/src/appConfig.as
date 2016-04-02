package  
{
	import com.hexagonstar.util.debug.Debug;
	import Command.*;
	import flash.display.MovieClip;
	import Model.*;
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import util.math.Path_Generator;
	import util.*;
	import util.math.Value_Transfer;
	import View.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.Visual_Version;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	
	import View.GameView.*;
	/**
	 * ...
	 * @author hhg
	 */
	public class appConfig 
	{
		//要unit test 就切enter來達成
		
		//singleton="false"
		[ObjectDefinition(id="Enter")]
		public var _LoadingView:LoadingView = new LoadingView();		
		public var _betView:betView = new betView();
		public var _HudView:HudView = new HudView();		
		
		//model		
		public var _Model:Model = new Model();
		public var _MsgModel:MsgQueue = new MsgQueue();
		public var _Actionmodel:ActionQueue = new ActionQueue();
		public var _fileStream:fileStream = new fileStream();
		
		//connect module
		public var _socket:WebSoketComponent = new WebSoketComponent();
		
		//command 
		public var _viewcom:ViewCommand = new ViewCommand();
		public var _state:StateCommand = new StateCommand();
		public var _dataoperation:DataOperation = new DataOperation();
		public var _betcom:BetCommand = new BetCommand();
		public var _regular:RegularSetting = new RegularSetting();
		public var _sound:SoundCommand = new SoundCommand();
		
		//util
		public var _path:Path_Generator = new Path_Generator();
		public var _value:Value_Transfer = new Value_Transfer();
		public var _debug:Visual_debugTool = new Visual_debugTool();
		public var _replayer:Visual_package_replayer = new Visual_package_replayer();
		public var _Version:Visual_Version = new Visual_Version();
		
		//visual		
		public var _timer:Visual_timer = new Visual_timer();
		public var _text:Visual_Text = new Visual_Text();		
		public var _progressbar:Visual_progressbar = new Visual_progressbar();		
		public var _theme:Visual_theme = new Visual_theme();		
		
		public var _downList:Visual_downList = new Visual_downList();
		public var _FinancialGraph:Visual_FinancialGraph = new Visual_FinancialGraph();
		public var _page_arrow:Visual_page_arrow = new Visual_page_arrow();
		public var _Item_list:Visual_Item_list = new Visual_Item_list();
		public var _ticket_binary:Visual_ticket_binary = new Visual_ticket_binary();
		public var _pop_hint:Visual_pop_hint = new Visual_pop_hint();
		
		//test
		public var _test:Visual_testInterface = new Visual_testInterface();
		
		//[ProcessSuperclass]
		//public var _vibase:ViewBase = new ViewBase();
		
		
		public function appConfig() 
		{
			Debug.trace("7PK init");
		}
	
	}

}