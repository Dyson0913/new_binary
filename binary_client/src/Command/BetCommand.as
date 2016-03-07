package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Interface.CollectionsInterface;
	import Model.*;
	import Model.valueObject.*;	
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
	import Res.*;
	import com.laiyonghao.Uuid;
	import ConnectModule.websocket.WebSoketComponent;
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
		
		[Inject]
		public var _socket:WebSoketComponent;
		
		public function BetCommand() 
		{
		
		}
		
		public function bet_init():void
		{
			//_model.putValue("coin_selectIdx", 2);
			_model.putValue("coin_list", 				[5, 10, 50, 100, 500, 1000, 5000, 10000]);
			_model.putValue("coin_limit_1000", [true, true, true, true, true, false, false, false]);
			_model.putValue("coin_limit_5000", [true, false, true, true, true, true, false, false]);
			_model.putValue("coin_limit_10000", [true, false, false, true, true, true, true, false]);
			_model.putValue("coin_limit_50000", [true, false, false, false, true, true, true, true]);
			//_model.putValue("after_bet_credit", 0);
			
			//閒對,閒,和,莊,莊對
			var betzone:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];			
			var betzone_name:Array = ["BetS7PKNone", "BetS7PKOnePair", "BetS7PKTwoPair", "BetS7PKTripple", "BetS7PKStraight", "BetS7PKFlush","BetS7PKFullHouse","BetS7PKFourOfAKind","BetS7PKStraightFlush","BetS7PKFiveOfAKind","BetS7PKRoyalFlush","BetS7PKPureRoyalFlush"];
			
			var bet_name_to_idx:DI = new DI();
			var bet_idx_to_name:DI = new DI();
			var _idx_to_result_idx:DI = new DI();
			for ( var i:int = 0; i < betzone.length ; i++)
			{
				bet_name_to_idx.putValue(betzone_name[i], i);
				bet_idx_to_name.putValue(i, betzone_name[i]);
				
				//nono = 0 -> 11 onePair= 1-> 10
				_idx_to_result_idx.putValue(i.toString(), (betzone.length-1) -i );
			}		
			
			
			_model.putValue("Bet_name_to_idx", bet_name_to_idx);		
			_model.putValue("Bet_idx_to_name", bet_idx_to_name);
			_model.putValue("idx_to_result_idx", _idx_to_result_idx);
			
			_model.putValue(modelName.AVALIBLE_ZONE_IDX, betzone);
			
			
			_model.putValue(modelName.COIN_SELECT_XY, [ [0, 0], [85, 0], [170, 0], [255, 0], [340, 0] ]);
			
			_model.putValue(modelName.COIN_STACK_XY,   [ [1612, 292], [1302, 292],  [998, 292], [686, 292], [378, 292], [68, 284],
																									  [1564, 100], [1276, 100],  [982,100], [694, 100], [398, 100], [106, 100]			
			]);
			
			_model.putValue(modelName.COIN_CANCEL_XY,   [ [1682, 307], [1372, 307],  [1068, 307], [756, 307], [448, 307], [138, 299],
																									  [1634, 115], [1346, 115],  [1052,115], [764, 115], [468, 115], [176, 115]			
			]);
			
			_model.putValue(modelName.COIN_BETTIMER_XY,   [ [1750, 307], [1440, 307],  [1136, 307], [824, 307], [516, 307], [206, 299],
																									  [1702, 115], [1414, 115],  [1120,115], [832, 115], [536, 115], [244, 115]			
			]);
			
			_model.putValue(modelName.COIN_AMOUNT_XY,   [ [1782, 292], [1472, 292],  [1168, 292], [876, 292], [568, 292], [258, 292],
																									  [1744, 120], [1456, 120],  [1162,120], [874, 120], [578, 120], [296, 120]			
			]);
			
			var poermapping:DI = new DI();			
			poermapping.putValue("BetS7PKNone", 13);
			poermapping.putValue("BetS7PKOnePair", 12);
			poermapping.putValue("BetS7PKTwoPair", 11);
			poermapping.putValue("BetS7PKTripple", 10);
			poermapping.putValue("BetS7PKStraight", 9);
			poermapping.putValue("BetS7PKFlush", 8);
			poermapping.putValue("BetS7PKFullHouse", 7);
			poermapping.putValue("BetS7PKFourOfAKind", 6);
			poermapping.putValue("BetS7PKStraightFlush", 5);
			poermapping.putValue("BetS7PKFiveOfAKind", 4);
			poermapping.putValue("BetS7PKRoyalFlush", 3);
			poermapping.putValue("BetS7PKPureRoyalFlush", 2);
			_model.putValue(modelName.BIG_POKER_MSG , poermapping);		
			
			var bet_idx_mapping:DI = new DI();			
			bet_idx_mapping.putValue(0, 13);
			bet_idx_mapping.putValue(1, 12);
			bet_idx_mapping.putValue(2, 11);
			bet_idx_mapping.putValue(3, 10);
			bet_idx_mapping.putValue(4, 9);
			bet_idx_mapping.putValue(5, 8);
			bet_idx_mapping.putValue(6, 7);
			bet_idx_mapping.putValue(7, 6);
			bet_idx_mapping.putValue(8, 5);
			bet_idx_mapping.putValue(9, 4);
			bet_idx_mapping.putValue(10, 3);
			bet_idx_mapping.putValue(11, 2);
			_model.putValue(modelName.BET_ZONE_MAPPING , bet_idx_mapping);			
			
			_model.putValue("power_jp",[0,0]);
			
			
			_Bet_info.putValue("self", [] ) ;
			_model.putValue("history_bet", []);
			
				var itemMapping:DI = new DI();			
			itemMapping.putValue("raise_up", 1);
			itemMapping.putValue("fall_down", 2);
			itemMapping.putValue("out_price", 3);
			itemMapping.putValue("In_price", 4);
		
			_model.putValue(modelName.BUY_ITEM_FRAME , itemMapping);		
			
		}		
		
		public function sendBet(betType:int):void {
			
			var bet_msg:Object = createBet(betType);
			if ( CONFIG::debug ) 
				{				
					//本機測試，不送封包
					/*var r:int = int(Math.random() * 5);
					if (r == 0 ) { 
						//測試下注失敗
						cleanBetUUID(bet_msg.id);
					}*/
				}		
				else
				{				
					_socket.SendMsg(bet_msg);
				}
			
		}
		
		//新增注單
		private function createBet(betType:int):Object {
			var uuid:Uuid = new Uuid();
			var total_bet_amount:int = get_total_bet(betType);
			var bet_amount:int = 0;
			var obs:Array = _Bet_info.getValue("self");
			for each(var ob:Object in obs) {
				if (ob["betType"] == betType && ob["id"] == "") {
					bet_amount += ob["bet_amount"];
					
					//寫入uuid，代表資料將被發送
					ob["id"] = uuid.toString();
				}
			}
				
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");					
			
			//一個注區一張單
			var bet:Object = {  
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":_model.getValue(modelName.Game_Name),
										   "game_round":_model.getValue("game_round"),
										   
										    "bet_type": idx_to_name.getValue( betType),
										    "bet_amount":bet_amount,
											"total_bet_amount":total_bet_amount,
											"id":uuid.toString()
										   
											};
			
			return bet;
		}
		
		//清除無uuid的注單(玩家按下取消鈕)
		public function cleanBetNoUUID(betType:int):void {
			var obs:Array = _Bet_info.getValue("self");
			var obs_new:Array = [];
			for each(var obj:Object in obs) {
				if (obj["betType"] == betType && obj["id"] == "") {
					//nothing
				}else {
					obs_new.push(obj);
				}
			}
			
			_Bet_info.putValue("self", obs_new);
			
			//刷新籌碼元件
			dispatcher(new ModelEvent("refreshCoin", betType));
		}
		
		//清除有uuid的注單(投注失敗)
		public function cleanBetUUID(uuid:String):void {
			var obs:Array = _Bet_info.getValue("self");
			var obs_new:Array = [];
			var betType:int = 0;
			for each(var obj:Object in obs) {
				if (obj["id"] == uuid) {
					betType = obj["betType"];
				}else {
					obs_new.push(obj);
					
				}
			}
			
			_Bet_info.putValue("self", obs_new);
			
			//刷新籌碼元件
			dispatcher(new ModelEvent("refreshCoin", betType));
			//餘額不足訊息
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			//idx += 1;
			if ( _Actionmodel.length() > 0) return false;

			//該區未送出金額加總
			var obs:Array = _Bet_info.getValue("self");
			var unconfim_amount:int = 0;
			for each(var ob:Object in obs) {
				if (ob["betType"] == idx && ob["id"] == "") {
					unconfim_amount += ob["bet_amount"];
				}
			}
			
			//押注金額判定(該區未送出金額不得超過餘額)
			if ( unconfim_amount + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			{
				utilFun.Log("unconfim_amount: " + unconfim_amount);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return false;
			}	
			
			utilFun.Log("betType = "+idx);
			var bet:Object = { "betType": idx,
											"bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount": _opration.array_idx("coin_list", "coin_selectIdx"),
										    "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx"),
											"id":""
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}	
		
		public function bet_local(e:Event,idx:int):Boolean
		{			
			//idx += 1;
			utilFun.Log("bet_local idx ="+idx);
			
			var bet:Object = { "betType": idx,
										   "bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount": _opration.array_idx("coin_list", "coin_selectIdx"),
										    "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx"),
											"id":""
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			
			//fake bet proccess
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			dispatcher(new ModelEvent("updateCoin"));
			
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
			//self_show_credit()
			
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"] + " idx = " + bet["bet_idx"] );
			//}
		}
		
		/*private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			//_model.putValue("after_bet_credit", credit - total);
		}*/
		
		public function all_betzone_totoal():Number
		{
			var betzone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			
			var total:Number = 0;
			for each (var i:int in betzone)
			{
				total +=get_total_bet(i);
			}
			return total;
		}
		
		public function get_total_bet(type:int):Number
		{
			if ( _Bet_info.getValue("self") == null) return 0;
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( type == -1)
				{
					total += bet["bet_amount"];
					continue;
				}
				else if( type == bet["betType"])
				{
					total += bet["bet_amount"];
				}
			}
			
			return total;
		}
		
		public function has_Bet_type(type:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type) return true;				
			}			
			return false;
		}
		
		public function Bet_type_betlist(type:int):Array
		{
			var bet_list:Array = _Bet_info.getValue("self");
			var arr:Array = [];
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type)
				{
					arr.push( bet["bet_amount"]);
				}
			}			
			return arr;
		}
		
		public function bet_zone_amount():Array
		{
			
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var mylist:Array = [];
			for ( var i:int = 0; i < zone.length; i++)
			{
				mylist.push(0);
			}
			
			var total:int = 0;
			for (  i = 0; i < zone.length; i++)
			{				
				var map:int = _opration.getMappingValue("idx_to_result_idx", zone[i]);
				var amount:int = get_total_bet(zone[i]);
				mylist.splice(map, 1, amount);
				total += amount;
			}
			mylist.push(total);
			return mylist;
		}
		
		public function check_jp():Number
		{
			//var array:Array = _model.getValue("power_jp");
			//for ( var i:int = 0;i< array.length
			//
			//return 
			
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var check_zone:Array = ["BetBWPlayer", "BetBWBanker"];
					
			var total:Number = 0;
			for ( var i:int = 0; i < check_zone.length ; i++)
			{
				var zone:int = name_to_idx.getValue(check_zone[i]);	
				total += get_total_bet(zone);
			}
			
			return total;
		}
		
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				if ( type == "table") data.push(bet_ob["betType"]);
				if ( type == "amount") data.push(bet_ob["bet_amount"]);								
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
				
				check_lost(resultob, betzon_idx);
				check_bingWin(resultob);
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
		
		public function check_lost(resultob:Object,betzon_idx:int):void
		{
			if ( resultob.win_state == "WSLost") 
			{
				var clean:Array = _model.getValue("clean_zone");
				clean.push (betzon_idx);
				_model.putValue("clean_zone",clean);
			}
			
		}
		
		public function check_bingWin(resultob:Object):void
		{
			//bigwin condition  type:player,winstat:!WSBWNormalWin && !WSWin
			//winst: winste  odd:result.odds		
			//大獎
			if ( resultob.win_state =="WSWin")
			{
					//bigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state);
				var bingwin:int = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.bet_type);
				_model.putValue("bigwin", bingwin);
				_model.putValue("winstr", bingwin);
				_model.putValue("win_odd",resultob.odds);
			}			
		}
		
		public function check_specail(resultob:Object):void
		{
		
		}
		
		public function check_powerbar(resultob:Object):void
		{
			//special condition
			//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTripple", "settle_amount": 0},
			//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTwoPair", "settle_amount": 0}
			if( resultob.bet_type =="BetBWBonusTwoPair") 
			{
				var extra:int = resultob.bet_amount * resultob.odds;
				if ( extra > 0)
				{
					var array:Array = _model.getValue("power_jp");
					array[0] = resultob.bet_amount * resultob.odds;
					_model.putValue("hintJp", 1);
				}				
			}
			if( resultob.bet_type =="BetBWBonusTripple") 
			{
				var extra_two:int = resultob.bet_amount * resultob.odds;
				if ( extra_two )
				{
					var array2:Array = _model.getValue("power_jp");
					array2[1] = resultob.bet_amount * resultob.odds;
					_model.putValue("hintJp", 1);
				}				
			}
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function Clean_bet():void
		{
			save_bet();
			_Bet_info.clean();			
			
			_Bet_info.putValue("self", [] ) ;
		}
		
		public function save_bet():void
		{
			var bet_list:Array = _Bet_info.getValue("self");
			//utilFun.Log("save_bet bet_list  = "+bet_list.length );
			if ( bet_list.length ==0) return;
			_model.putValue("history_bet", bet_list);
		}
		
		public function clean_hisotry_bet():void
		{
			_model.putValue("history_bet", []);
			dispatcher(new ModelEvent("can_not_rebet"));
		}
		
		public function need_rebet():Boolean
		{
			var bet_list:Array  = _model.getValue("history_bet");			
			if ( bet_list.length ==0) return false;
			
			return true;
		}
		
		public function re_bet():void
		{
			var bet_list:Array  = _model.getValue("history_bet");
			
			utilFun.Log("check bet_list  = " + bet_list );
			if ( bet_list == null) return;
			
			//與賓果不同,同一注區會分多筆,必需要等上一筆注單確認,再能再下第二筆,不然total_bet_amount,值會錯
			utilFun.Log("bet_list  = " + bet_list.length );
			if ( bet_list.length != 0)
			{			
				var coin_list:Array = _model.getValue("coin_list");
				var bet:Object = bet_list[0];				
				var mybet:Object = { "betType": bet["betType"],
													  "bet_idx":bet["bet_idx"],
														"bet_amount": coin_list[ bet["bet_idx"]],
														"total_bet_amount": (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]])
				};
			
				utilFun.Log("bet_info  = " + mybet["betType"] +" amount =" + mybet["bet_amount"] + " idx = " + bet["bet_idx"] +" total_bet_amount " +  (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]])  );
				bet_list.shift();
				_model.putValue("history_bet",bet_list);
				dispatcher( new ActionEvent(mybet, "bet_action"));
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			}
		}
		
		public function handle_odd(checkarr:Array):void
		{
			//handle data
			var total:Array = checkarr; //_model.getValue("round_paytable");			
			var frame:Array = [];
			var xmark:Array = [];
			var zero:Array = [];
			var odd:Array  = [];
			var idx:int = 0;
			var select_idx:Array = [];
			
			for ( var i:int = 0; i < total.length; i++)
			{				
				if ( total[i] == -1)
				{
					zero.push(1);
				}
				else 
				{
					frame[idx] = _opration.getMappingValue(modelName.BET_ZONE_MAPPING, i);
					odd[idx] = total[i];
					idx++;
					select_idx.push(i);
					xmark.push(12);					
				}
			}
			_model.putValue("paytable_frame", frame.reverse());
			_model.putValue("paytable_display_idx", select_idx);
			
			var odd_with_idx:Array = create_with_idx(total);
			odd_with_idx.sort(sort_high_to_low);
			
			var oddvalue:Number =  odd_with_idx[0]["value"];			
			if ( oddvalue>= 15 && oddvalue != -1) 
			{
				var idx:int = odd_with_idx[0]["origi_position"];
				_model.putValue("highest_idx", idx);
			} 
			else _model.putValue("highest_idx", -1);
			
			oddvalue = odd_with_idx[1]["value"];
			if ( oddvalue >= 15 && oddvalue != -1) 
			{
				var idx:int = odd_with_idx[1]["origi_position"];
				_model.putValue("sec_high_idx", idx);
			} 
			else _model.putValue("sec_high_idx", -1);
			
			
			xmark.push.apply(xmark, zero);
			_model.putValue("paytable_xmark", xmark);			
			
			odd.reverse();			
			var copyarr:Array = [];
			copyarr.push.apply(copyarr, odd );
			_model.putValue("odd_data",copyarr);
		}
		
		private function create_with_idx(raw_arr:Array):Array
		{
			var copy_instance:Array = [];
			copy_instance.push.apply(copy_instance, raw_arr);
			
			var ob_with_origi_idx:Array = [];
			
			for ( var i:int = 0; i < raw_arr.length; i++)
			{
				var info_ob:Object = { "value": raw_arr[i],												
													   "origi_position": i
				};
				
				ob_with_origi_idx.push(info_ob);
			}
			
			return ob_with_origi_idx;
		}
		
		//籌碼面額換算
		public function getAllcoinData(betType:int):Array {
			var total:int = get_total_bet(betType);			
			var allcoinData:Array = [];
			var coin:Array = _model.getValue("coin_list").concat();
			//由大到小
			coin.reverse();
			
			for each(var chipValue:int in coin){
				var coinNum:int = total / chipValue;
				for (var i:int = 0; i < coinNum; i++ ) {
					allcoinData.push(chipValue);
				}
				
				total = total % chipValue;
			}
			
			return allcoinData;
		}
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function sort_high_to_low(a:Object, b:Object):int 
		{
			if ( a["value"] >b["value"]) return -1;
			else if ( a["value"] < b["value"]) return 1;
			else return 0;			
		}
		
		private function sort_low_to_high(a:Object, b:Object):int 
		{
			if ( a <b) return -1;
			else if ( a > b) return 1;
			else return 0;			
		}
	}

}