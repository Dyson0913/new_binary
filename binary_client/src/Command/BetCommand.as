package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;	
	import Model.*;
	import Model.valueObject.*;	
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
	import Res.*;
	import com.laiyonghao.Uuid;
	import Model.PageStyleModel;
	
	/**
	 * user bet action
	 * @author hhg4092
	 */
	public class BetCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _model:Model;
		
		public var _Bet_info:DI = new DI();
		
		
		public static const ITEM_NAME:String = "item_name";	
		public static const BUY_TYPE:String = "buy_type";	
		public static const BUY_AT_PRICE:String = "buy_at_price";	
		public static const BUY_POINT:String = "buy_point";	
		public static const EXPECT_VALUE:String = "expect_value";	
		public static const REST_TIME:String = "rest_time";	
		
		public static const buy_ticket:String = "buy_ticket";	
		
		public static const up:String = "raise_up";	
		public static const down:String = "fall_down";	
		public static const outprice:String = "out_price";	
		public static const Inprice:String = "In_price";	
		
		public function BetCommand() 
		{
		
		}
		
		public function bet_init():void
		{			
			_model.putValue("game_round", 1);
			_model.putValue(modelName.Game_Name, "Super7PK");
			
			var state:DI = new DI();
			state.putValue("NewRoundState", gameState.NEW_ROUND);
			state.putValue("StartBetState", gameState.START_BET);
			state.putValue("EndBetState", gameState.END_BET);
			state.putValue("OpenState", gameState.START_OPEN);
			state.putValue("EndRoundState", gameState.END_ROUND);			
			_model.putValue("state_mapping", state);
			
			_Bet_info.putValue("self", [] ) ;
			
			_model.putValue("history_bet", []);
			
			var itemMapping:DI = new DI();			
			itemMapping.putValue("raise_up", 1);
			itemMapping.putValue("fall_down", 2);
			itemMapping.putValue("out_price", 3);
			itemMapping.putValue("In_price", 4);
			
			_model.putValue(modelName.BUY_ITEM_FRAME , itemMapping);
			
			//所有購買目錄
			_model.putValue("all_catalog", ["貨幣","指數","股價"] );
			
			//各目錄選項
			_model.putValue("all_list", [ ["歐元", "美元", "英鎊", "加幣", "日元", "韓元", "港幣", "新台幣", "人民幣", "比特幣", "新加坡幣", "加幣", "法郎", "南非幣"],
														  ["上海A股", "上海B股", "上海綜合", "香港恆生", "香港國企", "日經225", "台灣加權", "韓國100", "鈕西蘭50", "澳洲ASX", "菲律賓PSEI", "印尼綜合", "印度BSE30", "深圳B股"],
														  ["2317鴻海", "2332友訊", "2352佳世達", "2356英業達", "2365昆盈", "2390云辰", "2392正崴", "2423固緯", "2424隴華", "2451創見", "2481連宇", "2497怡利電", "2498宏達電", "3024憶聲"]
														]
			);			
			
			//目前選擇的目錄
			_model.putValue("cata_idx", 0);
			
			//選擇的
			_model.putValue("Current_item_selcet_idx", 0);
			
			//目前選擇的商品
			_model.putValue("current_item", []);
			
			//一頁顥示資料
			_model.putValue("one_page_data", []);
			
			//一個選項所有資料
			_model.putValue("one_catalog_data", []);
			
			//page module
			var page:DI = new DI();
			
			var stage_1_Model:PageStyleModel = new PageStyleModel();
			stage_1_Model.UpDateModel([], 6);			
			page.putValue("stage1", stage_1_Model);
			
			var buy_ticket_Model:PageStyleModel = new PageStyleModel();
			buy_ticket_Model.UpDateModel([], 9);
			page.putValue("buy_ticket", buy_ticket_Model);
			
			_model.putValue("page_module", page);
			_model.putValue("current_page_module", new PageStyleModel());
			
			
		}		
		
		//----------------------------------------------------------------------客制
		[MessageHandler(type = "Model.ModelEvent", selector = "first_pull_update")]
		public function first_pull_update(para:ModelEvent):void
		{
			
			_model.putValue("cata_idx", para.Value);
			
			//TODO state diff
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if (state == gameState.NEW_ROUND) 
			{
				set_current_page_module(_model.getValue("all_list")[para.Value], "stage1" );
				update_select_item(_model.getValue("Current_item_selcet_idx"));
				
				//更新item_list
				dispatcher(new ModelEvent("page_update"));	
			}
			if (state == gameState.START_BET) 
			{
				set_current_page_module(_model.getValue("all_list")[para.Value], "stage1" );
				update_select_item(_model.getValue("Current_item_selcet_idx"));
				
				//換目錄自動選擇第一個商品
				dispatcher(new ModelEvent("sec_pull_update", 0));
			}
			if ( state == gameState.END_ROUND) 
			{
				set_current_page_module(_model.getValue("all_list")[para.Value], "buy_ticket" );				
				//更新ticket bynary
				dispatcher(new ModelEvent("page_update"));	
			}
			
		}
		
		//更新目前page model 項目時,也一拼更新該page_model 一頁所需的data,以及讓項目的所有data
		public function set_current_page_module(dynamic_module:Array,pagekind:String ):void
		{
			var current_module:PageStyleModel = _model.getValue("page_module").getValue(pagekind);
			current_module.UpDateModel(dynamic_module, current_module.PageAmount);
			_model.putValue("current_page_module", current_module);			
			
			if (pagekind == "buy_ticket") {
				var current_module:PageStyleModel = _model.getValue("page_module").getValue("buy_ticket");
				current_module.GoLastPage();
			}
			
			//一頁data			
			update_page_and_all();
			
			//該項目所有選項
			if ( pagekind != "buy_ticket") 
			{
				_model.putValue("one_catalog_data", dynamic_module);
			}
			
		}	
		
		public function update_page_and_all():void
		{
			var current_Model:PageStyleModel =  _model.getValue("current_page_module");
			_model.putValue("one_page_data", current_Model.GetPageDate());			
		}
		
		public function update_select_item(idx:int):void
		{
			var current_Model:PageStyleModel =  _model.getValue("current_page_module");
			_model.putValue("current_item", current_Model.GetOneDate(idx));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "sec_pull_update")]
		public function sec_pull_update(para:ModelEvent):void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if (state == gameState.NEW_ROUND) 
			{
				_model.putValue("Current_item_selcet_idx", para.Value );
				dispatcher(new ModelEvent("theme_update", 1));
			}
			if (state == gameState.START_BET) 
			{
				_model.putValue("Current_item_selcet_idx", para.Value );
				update_select_item(_model.getValue("Current_item_selcet_idx"));
				dispatcher(new ModelEvent("graph_update"));
			}
		}
		
		//----------------------------------------------------------------------share
		//新增注單
		private function createBet(betType:String):Object 
		{
			var uuid:Uuid = new Uuid();
			
			var frame:int = _opration.getMappingValue(modelName.BUY_ITEM_FRAME, betType);
			var buy_at_price:Array = [];
			var buy_range:Array  = [];
			
			if ( betType == "fall_down") 
			{
				buy_at_price.push ( _model.getValue("price_low") );
				buy_range = buy_range.concat (_model.getValue("range_point")[1]) ;
			}
			else if ( betType == "raise_up") 
			{
				buy_at_price.push ( _model.getValue("price_high") );
				buy_range = buy_range.concat (_model.getValue("range_point")[1]) ;
			}
			else if ( betType == "out_price") 
			{
				buy_at_price.push ( _model.getValue("price_high") );				
				buy_range = buy_range.concat (_model.getValue("range_point")) ;
			}
			else 
			{				
				buy_at_price.push ( _model.getValue("price_low") );
				buy_range = buy_range.concat (_model.getValue("range_point")) ;
			}
			
			
			var bet:Object = {  
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":_model.getValue(modelName.Game_Name),
										   "game_round":_model.getValue("game_round"),
										   									
											"id":uuid.toString(),
											"item_name":_model.getValue("current_item"),
											"buy_type":frame,
											"buy_at_price": buy_at_price,
											"buy_point":buy_range,
											"expect_value":_model.getValue("expect_profit"),
											"rest_time":_model.getValue("order_time")											
											};
			var resttime:String = _model.getValue("order_time");
			return bet;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "buy_ticket")]
		public function bet_send(para:ModelEvent):void		
		{
			var behavior:String = para.Value[0];
			if ( _Actionmodel.length() > 0) return ;
			var bet:Object = createBet(behavior);
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			
			dispatcher(new ModelEvent("updatet_icket"));
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			//idx += 1;
			if ( _Actionmodel.length() > 0) return false;
			
			//押注金額判定(該區未送出金額不得超過餘額)
			//if ( _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			//{
				//utilFun.Log("unconfim_amount: " + unconfim_amount);
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				//return false;
			//}	
			
			
			//dispatcher( new ActionEvent(bet, "bet_action"));
			//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			//dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();
			//bet_ob["bet_amount"] -= get_total_bet(bet_ob["betType"]);
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [bet_ob]);
				
			}
			else
			{
				var bet_list:Array = _Bet_info.getValue("self");
				bet_list.push(bet_ob);
				_Bet_info.putValue("self", bet_list);
			}
			_Actionmodel.dropMsg();
			//self_show_credit()
			
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"] + " idx = " + bet["bet_idx"] );
			//}
		}
		
		//取得某一種key值
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				data.push(bet_ob[type]);
			}
			return data;
		}		
		
		public function get_key_info(type:String,target:Array):Array
		{
			var arr:Array = target;		
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				data.push(bet_ob[type]);
			}
			return data;
		}		
		
		public function get_my_betlist():Array
		{		
			return _Bet_info.getValue("self");		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_data_parse():void
		{
			var settle_amount:Array = [];
			var zonebet_amount:Array = [];		
			
			_model.putValue("clean_zone", []);
			_model.putValue("bigwin",null);
			_model.putValue("sigwin",-1);
			_model.putValue("win_odd", -1);
			_model.putValue("winstr", -1);
			_model.putValue("hintJp", -1);
			
			var total_bet:int = 0;
			var total_settle:int = 0;
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var betZone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);			
			var num:int = betZone.length;	
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state );
				
				var betzon_idx:int = _opration.getMappingValue("Bet_name_to_idx", resultob.bet_type);			
			//	check_specail(resultob);
			//	check_powerbar(resultob);
				
				//總押注和贏分
				var display_idx:int = _opration.getMappingValue("idx_to_result_idx", betzon_idx);
				settle_amount[ display_idx] =  resultob.settle_amount;				
				zonebet_amount[ display_idx ]  = resultob.bet_amount;				
				total_settle += resultob.settle_amount;
				total_bet += resultob.bet_amount;
			}			
			
			settle_amount.push(total_settle);
			zonebet_amount.push(total_bet);
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total_settle);
			_model.putValue("result_total_bet", total_bet);
			
			utilFun.Log("result_settle_amount =" + settle_amount);
			utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			utilFun.Log("total_settle =" + total_settle);
			utilFun.Log("zonebet_amount =" + zonebet_amount);
			
			if ( _model.getValue("bigwin") != -1)
			{
				dispatcher(new ModelEvent("settle_bigwin"));
			}
			else 	if ( _model.getValue("hintJp") != -1)
			{				
				dispatcher(new Intobject(_model.getValue("sigwin"), "power_up"));
			}
			else
			{
				dispatcher(new Intobject(1, "settle_step"));
			}
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function Clean_bet():void
		{
			//save_bet();
			//_Bet_info.clean();			
			
			//_Bet_info.putValue("self", [] ) ;
		}
		
		public function save_bet():void
		{
			var bet_list:Array = _Bet_info.getValue("self");		
			if ( bet_list.length ==0) return;
			_model.putValue("history_bet", bet_list);
		}
		
		public function clean_hisotry_bet():void
		{
			_model.putValue("history_bet", []);
			dispatcher(new ModelEvent("can_not_rebet"));
		}
		
		public function cleanBet(idx:int ):void 
		{
			var obs:Array = _Bet_info.getValue("self");			
			obs.splice(idx,1);
			_Bet_info.putValue("self", obs);
		}
	}

}