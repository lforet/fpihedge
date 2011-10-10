//+------------------------------------------------------------------+
//|                                 LPFs FPI Hedge .mq4              |
//|                                 Copyright © 2011, Laird P Foret  |
//|                                 laird@isotope11.com              |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Laird P Foret"
#property link      "laird@isotope11.com"

string CurrencyPairs[60] = {
   "AUDUSD", "AUDNZD", "AUDCAD", "AUDJPY", "AUDCHF", // "AUDSGD", 
   "CADCHF", "CADJPY", "CHFJPY", "CADSGD", "CHFSGD",
   "EURJPY", "EURCHF", "EURNOK", "EURSEK", "EURGBP", "EURCAD", "EURAUD", "EURUSD", "EURTRY", //"EURSGD",
   "EURDKK", "EURPLN", "EURNZD", //"EURHUF",
   "GBPJPY", "GBPCHF", "GBPAUD", "GBPCAD", "GBPUSD", "GBPNZD",
   "NZDJPY", "NZDUSD", "NZDCHF", "NZDCAD",  "NOKJPY", //"NZDSGD",
   "SGDJPY", "SEKJPY",
   "TRYJPY",
   "USDJPY", "USDCHF", "USDCAD", "USDDKK", "USDNOK", "USDSEK", "USDTRY", "USDHKD", "USDSGD",
   "USDHUF", "USDZAR", 
   "ZARJPY",
   };
 //2011.08.31 18:49:43	LPF FPI Hedge V4 EURJPY,H1: Validated Pair List: AUDUSD, AUDNZD, AUDCAD, AUDJPY, AUDCHF, CADJPY, CHFJPY, EURJPY, EURCHF, EURGBP, EURCAD, EURAUD, EURUSD, EURDKK, EURPLN, EURNZD, GBPJPY, GBPCHF, GBPAUD, GBPCAD, GBPUSD, GBPNZD, NZDJPY, NZDUSD, NZDCHF, NZDCAD, USDJPY, USDCHF, USDCAD, USDDKK, USDNOK, USDTRY, USDHKD, USDSGD, USDHUF, USDZAR, ZARJPY, 

string Indexes[] = { "EUR","USD","JPY","GBP","CHF","CAD","NZD","AUD"};
   
   
string ValidatedPairs[];
string ValidatedRings[][3];

       int      Version = 1010201101;
       //FPI - Fraction Product Inefficientcy Hedge
       string   EAName = "LPFs FPI Hedge";   
       double   FPI = 0.0;  
       double   FPI2 = 0.0;   
       double   BSS_FPI = 0.0;
       double   SBB_FPI = 0.0; 
       double   FPIHighest = 1.0;
       double   FPILowest = 1.0;
       double   FPI2Highest = 1.0;
       double   FPI2Lowest = 1.0;
       double   AcctInitBal = 0.0;
       double   AcctBalLowest = 0.0;
       double   AcctBalHighest = 0.0;   
       double   CurrentProfit = 0.0;  
       int      RingCount = 0;
       int      iterations = 0;
       int      maintenance_iterations = 0;
       double   Ring1DirectPrice = 0.0;
       double   Ring1Spread = 0.0;
       double   Ring1BID = 0.0;
       double   ArbitrageDif = 0.0;
      // int      UniqueMagicNumbers[];
       //double   RingTradeProfits[][3];
       double   RTA[][3]; //0=magic number, 1=low profit, 2=high profit
       
extern string   M1 =             "General Settings";
extern bool     LiveTrades = true; 
extern bool     NFACompliance = false;  
extern bool     CurrentSymbolTrading = true;   
       int      Magic_Number = 1234;
extern string   Triggers     = "=== FPI Trigger Points ===";
extern double   LoFPI        = 0.9976;
extern double   HiFPI        = 1.0022;
extern double   ProfitTrigger= 4.5;
extern double   Hard_Profit_Stop = 99.0;
extern double   TrailingStopPercentage = 15.0;
extern string   Rings        = "=== Currency pairs setting ===";
       double   lot1         = 1.0;
       double   lot2         = 1.0;
       double   lot3         = 1.0;
extern double   Lot1Additional = 0.0;
extern double   Lot2Additional = 0.0;
extern double   Lot3Additional = 0.0;
extern bool     Emergency_CloseAllTrades = false;
       double   minlot       = 0.0;
       datetime InvalidTradeTime = -1;
       datetime RunTime;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   // ramdomize timer
   //string txt;
   //string sym = Symbol();
   //int handle=FileOpen("tradinglock.dat", FILE_BIN|FILE_WRITE|FILE_READ);
   //Print ("in INIT: file handle=", handle);
   //Print(sym, " txt = ",txt);
   //FileWriteString(handle, sym, 6);
   //Print (FileSize(handle), StringLen(sym));
   //FileSeek(handle, 0, SEEK_SET);
   //txt = FileReadString(handle, 6);
   //Print("txt = ",txt);
   //if (txt == Symbol() ) Print ("MATCH");
   //FileClose(handle);
   //bool islocked;
   //for (int v=0;v<4;v++){
   //   islocked = LockTrading();
   //   if (islocked == true) Print ("trading file is locked!!");   
   //   if (islocked == false) Print ("trading file is NOT LOCKED");
   //}   
   //if (IsTradingLocked() == true) Print ("trading file is locked!!");
   //if (IsTradingLocked() == false) Print ("trading file is NOT LOCKED");
   //Sleep(1000);
   //LockTrading();   
   //if (IsTradingLocked() == true) Print ("trading file is locked!!");
   //if (IsTradingLocked() == false) Print ("trading file is NOT LOCKED");
   //Sleep(3000);
   //Print ("trying to lock for the third time");
   //LockTrading();   
   //if (IsTradingLocked() == true) Print ("trading file is locked!!");
   //if (IsTradingLocked() == false) Print ("trading file is NOT LOCKED");
   //UnLockTrading();
   //Sleep(1000);
   //LockTrading();
   //Sleep(2000);
   
   //if (IsTradingLocked() == true) Print ("locking file successful!");
   //if (IsTradingLocked() == false) Print ("NOT LOCKED");
   //Sleep(1000);
   
   //Print ("free margin=", AccountFreeMarginCheck( Symbol() ,OP_SELL,.01) );
   //Enough_Funds_To_Trade();

 
   MathSrand(TimeLocal());

   RunTime = TimeCurrent();
   
   AcctInitBal =  AccountEquity()- AccountBalance();
   if (IsTradingLocked() == true) UnLockTrading();

//----

   minlot = MarketInfo(Symbol(), MODE_MINLOT);
   Print ("Minimun Lot Size= ", minlot);
   
   //   string jjj[3] = {"EURCHF", "EURUSD", "USDCHF",};
   //CalculateLots(jjj);
   
   
   
   
   if (Emergency_CloseAllTrades == true ) EmergencyCloseAllTrades();
   DisplayStats();
   CreateValidPairsArray();
   
   // hedge test
   //Print ("Calling hedge_this...");
   //Hedge_This("EURSEK", OP_BUY, 1.0);
   
   
   CreateRingArray();
   RingCount = ArrayRange(ValidatedRings, 0);
   Print ("Pairs Being Monitored: ", RingCount);
   RebuildRTA();
   Update_All_RTA_Profits();
   Print (" Total Ring Trades Open: ", ArrayRange(RTA,0));
   string triangle[3];
   for (int x=0;x<RingCount;x++){
      for(int i=0;i<3;i++){
         triangle[i] = ValidatedRings[x][i];
         //Print ( i, triangle[i]);
      }
      //GenerateMagicNumber(triangle);
      ValidateRingOrder(triangle); 
      ValidateRingMath(triangle);
      //CalculateLots(triangle);
      //Sleep(1000);
   }
   CloseAllNonValidTrades();
   RebuildRTA();
   return(0);
  }
  
  
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ArrayResize(ValidatedRings,0);
   ArrayResize(RTA,0);
   ArrayResize(ValidatedPairs,0);
   iterations = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {

   if (Emergency_CloseAllTrades == true ) EmergencyCloseAllTrades();
   string triangle[3];
   int i, x;
   int local_MagicNum;
   if (Emergency_CloseAllTrades == false ){
      iterations++;
      maintenance_iterations++;
      for (x=0;x<RingCount;x++){
         for(i=0;i<3;i++){
            triangle[i] = ValidatedRings[x][i];
            //Print ( i, triangle[i]);
         }
         local_MagicNum = GenerateMagicNumber(triangle); 
         Arbitrage(triangle);
         //Close all trades rings that have less than 3 trades open
         // this need to be handled for mult-bot trading
         CloseAllNonValidTrades();      
         MonitorTrailingStop(local_MagicNum); 
         Check_Hard_Profit_Stop(local_MagicNum);
         CurrentProfit = AccountEquity()- AccountBalance();
         DisplayStats();
         //Sleep(10);
      }
   }

   //if (maintenance_iterations > 30){
   //   maintenance_iterations = 0;
      //RebuildRTA();
   //   CloseAllNonValidTrades(); 
      //Update_All_RTA_Profits();
      //RebuildRTA();
   //} 
     
   if (MathMod(OrdersTotal(),3) > 0 || (ArrayRange(RTA,0) != (OrdersTotal() / 3)) || ( (RingCount*3) !=  OrdersTotal() ) ) RebuildRTA();
   Update_All_RTA_Profits();
   DisplayStats();
   Sleep (50);
   return(0);
  }
  
//+------------------------------------------------------------------+
void CalculateLots(string Pairs_Ring[]){ 
   double Size_3; 
                
   lot1 = (minlot * 10);
   
   //determine pair 2 & 3 lot size
   double Size_2 = NormalizeDouble((MarketInfo(Pairs_Ring[0],MODE_TICKVALUE) * lot1) / MarketInfo(Pairs_Ring[1],MODE_TICKVALUE),2);
   double tmp_lot2 = (MathRound((Size_2 * 10))) * minlot;
   double abs_dif2 = MathAbs((tmp_lot2 - Size_2));
   double tmp_lot3 = MarketInfo(Pairs_Ring[1],MODE_ASK); 
   double tmp_lot33 = (MathRound((tmp_lot3 * 10))) * minlot;
   double abs_dif3 = MathAbs((tmp_lot3-tmp_lot33));
/*   
   Print ("abs_dif2= ", abs_dif2, "  abs_dif3= ", abs_dif3);   
   if (abs_dif2 < abs_dif3){
      Print ("Using Tickvalue method: calculating lot 2...");
      Size_3 = NormalizeDouble((MarketInfo(Pairs_Ring[0],MODE_TICKVALUE) * lot1) / MarketInfo(Pairs_Ring[2],MODE_TICKVALUE),2);
      lot1 = lot1 + Lot1Additional;
      lot2 = ((MathRound((Size_2 * 10))) * minlot) + Lot2Additional;
      lot3 = ((MathRound((Size_3 * 10))) * minlot) + Lot3Additional;
   }
   if (abs_dif3 <= abs_dif2 ){
      Print ("Using my method: calculating lot3...");
      lot1 = lot1 + Lot1Additional;
      lot2 = (minlot * 10) + Lot2Additional;
      lot3 = tmp_lot33 + Lot3Additional;
   } 
 */     
   //trancost method
   //Size_2 = NormalizeDouble((MarketInfo(Pairs_Ring[0],MODE_TICKVALUE) * lot1) / MarketInfo(Pairs_Ring[1],MODE_TICKVALUE),2);
   //Size_3 = NormalizeDouble((MarketInfo(Pairs_Ring[0],MODE_TICKVALUE) * lot1) / MarketInfo(Pairs_Ring[2],MODE_TICKVALUE),2);
   //double TranCost = (Size_2 * MarketInfo(Pairs_Ring[1],MODE_TICKVALUE) * MarketInfo(Pairs_Ring[1],MODE_SPREAD)+ 
   //                   Size_3 * MarketInfo(Pairs_Ring[2],MODE_TICKVALUE) * MarketInfo(Pairs_Ring[2],MODE_SPREAD) );
   //double TranCost2= ( (minlot * 10) * MarketInfo(Pairs_Ring[1],MODE_TICKVALUE) * MarketInfo(Pairs_Ring[1],MODE_SPREAD)+ 
   //                   tmp_lot3 * MarketInfo(Pairs_Ring[2],MODE_TICKVALUE) * MarketInfo(Pairs_Ring[2],MODE_SPREAD) );
                      
   //Print ("TranCost= ", TranCost, " TranCost2= ", TranCost2); 
   //if (TranCost < TranCost2){
      //Print ("Using Tickvalue method: calculating lot 2...");
   //   Size_3 = NormalizeDouble((MarketInfo(Pairs_Ring[0],MODE_TICKVALUE) * lot1) / MarketInfo(Pairs_Ring[2],MODE_TICKVALUE),2);
   //   lot1 = lot1 + Lot1Additional;
   //   lot2 = MathRound((Size_2 / minlot)) * minlot + Lot2Additional;
   //   lot3 = MathRound((Size_3 / minlot)) * minlot + Lot3Additional;
   //}
   //if (TranCost2 <= TranCost){
      //Print ("Using my method: calculating lot3...");
      lot1 = lot1 + Lot1Additional;
      lot2 = (minlot * 10) + Lot2Additional;
      lot3 = tmp_lot33 + Lot3Additional;
   //}   
   //Print ( "lot2= ", lot2, " Size_2= ", Size_2, "  Size_3= ", Size_3, "  lot3= ", lot3, "  tmp_lot3= ", tmp_lot3, "  lot33= ", tmp_lot33);
     Print ("lot1:", lot1, " lot2:", lot2, " lot3:", lot3);     
}

 
// =========================================================================================== //
//                    Counts # of pairs in a given array                                       //
// =========================================================================================== //
int Count_Pairs2 (string local_pairs[]){
   int x, y;
   int count = 0;
   x = 0;
   Print ("Counting Trading Pairs...");
   //Print ("array size = ", ArraySize(local_pairs));
   if (ArraySize(local_pairs) > 0){
      for(int i=0;i<ArraySize(local_pairs);i++){
         if (local_pairs[i] != ""){   
            count++;    
            //Print ("Counting Pairs2: ", count, " = ", local_pairs[i]);
            //if (local_pairs[i] == "") Print ("found nothing");
            //Sleep(1000);
         }
      }
    } else Print ("No pairs in array to count");
   Print ("Pairs in database: ", count); 
   return (count);
}
  
// =========================================================================================== //
//                    Calculates FPI and executes orders if appropriate                        //
// =========================================================================================== //
void Arbitrage(string Pairs_Ring[]){
   RefreshRates();

   int    Ticket;
   int    trycount = 0;
   int    Error_Code = 0;
   bool   continue_trade = False;
          Ring1BID = NormalizeDouble(MarketInfo(Pairs_Ring[0],MODE_BID),Digits);
   double Ring1ASK = NormalizeDouble(MarketInfo(Pairs_Ring[0],MODE_ASK),Digits);
   double Ring1AVG = NormalizeDouble(((Ring1BID + Ring1ASK) / 2),Digits);
          Ring1Spread = MarketInfo(Pairs_Ring[0],MODE_SPREAD) * MarketInfo(Pairs_Ring[0],MODE_POINT);
          Ring1DirectPrice = Ring1BID  + Ring1Spread;

   double Ring2ASK = NormalizeDouble(MarketInfo(Pairs_Ring[1],MODE_ASK),Digits);
   double Ring2BID = NormalizeDouble(MarketInfo(Pairs_Ring[1],MODE_BID),Digits);
   double Ring2AVG = NormalizeDouble(((Ring2BID + Ring2ASK) / 2), Digits);
   double Ring2Spread = MarketInfo(Pairs_Ring[1],MODE_SPREAD) * MarketInfo(Pairs_Ring[1],MODE_POINT);
   //double Ring2Price = Ring2ASK - (Ring2Spread*MarketInfo(Pairs_Ring[1],MODE_POINT));
   double Ring2Price = Ring2ASK - Ring2Spread;

   double Ring3ASK = NormalizeDouble(MarketInfo(Pairs_Ring[2],MODE_ASK),Digits);
   double Ring3BID = NormalizeDouble(MarketInfo(Pairs_Ring[2],MODE_BID),Digits);
   double Ring3AVG = NormalizeDouble(((Ring3BID + Ring3ASK) / 2),Digits);
   double Ring3Spread = MarketInfo(Pairs_Ring[2],MODE_SPREAD) * MarketInfo(Pairs_Ring[2],MODE_POINT);
   //double Ring3Price = Ring3ASK - (Ring3Spread*MarketInfo(Pairs_Ring[2],MODE_POINT));
   double Ring3Price = Ring3ASK - Ring3Spread;

   double IndirectASK = NormalizeDouble((Ring2ASK)*(Ring3ASK),Digits);
   double IndirectBID = NormalizeDouble((Ring2BID)*(Ring3BID),Digits);
   double IndirectAVG = NormalizeDouble((Ring2AVG * Ring3AVG),Digits);
   double IndirectPrice = NormalizeDouble((Ring2Price * Ring3Price),Digits);
   
   int Slippage = 2;
   
   double ArbitrageDifPips =  ((Ring1BID + Ring1Spread*Point) - IndirectASK); 

   //double ArbitrageDif = (Ring1BID-IndirectASK);
   ArbitrageDif = (Ring1DirectPrice - IndirectPrice);
   //if (ArbitrageDif < Ring1Spread ) Print (" Ring1DirectPrice= ", Ring1DirectPrice, "  IndirectPrice= ", IndirectPrice, "  Ring1Spread=",  Ring1Spread, "  Dif= ", ArbitrageDif);
   FPI =  Ring1AVG * (1/ Ring2AVG) * (1/Ring3AVG);

   if (FPI > FPIHighest) FPIHighest = FPI;
   if (FPI < FPILowest) FPILowest = FPI;
   
   if (CurrentProfit < AcctBalLowest) AcctBalLowest = CurrentProfit;
   if (CurrentProfit > AcctBalHighest) AcctBalHighest = CurrentProfit;
   if (AcctBalHighest == 0) AcctBalHighest = AcctBalLowest; 
   int CurrentRingTrades = 0;
   
   string Trade_Type = "NT";
   if(FPI < LoFPI) Trade_Type = "BSS";
   if(FPI > HiFPI) Trade_Type = "SBB";

   string Stars = "******";
   int Magic_Number = GenerateMagicNumber(Pairs_Ring); 
   if ( Trade_Type !="NT"){
      if ( (CountOrders(Magic_Number) < 3) ){
         CalculateLots(Pairs_Ring); 
         continue_trade = true;         
         if ( (iterations > 25) && (LiveTrades == true) && (NFACheck(Pairs_Ring) == true) &&
            (Emergency_CloseAllTrades == false) && (Enough_Funds_To_Trade() == true) ){
            if ( Trade_Type == "BSS" ) Print ("In Arbitrage FPI < LoFPI: Attempting to Lock Trading");
            if ( Trade_Type == "SBB" ) Print ("In Arbitrage FPI > HiFPI: Attempting to Lock Trading");
            if ( LockTrading() == true){ 
                  if ( Trade_Type == "BSS" ) Print (" FPI < FPI Trigger= ", LoFPI, "  FPI= ", FPI);
                  if ( Trade_Type == "SBB" ) Print (" FPI > FPI Trigger= ", HiFPI, "  FPI= ", FPI);
                  Print ("Open Trades < 3, iterations > 25, LiveTrades = True, NFACheck= OK, FundsCheck=OK....");
                  Print ("New Trades Authorized: ", Pairs_Ring[0], " ", Pairs_Ring[1], " ", Pairs_Ring[2]);
                 //************************************ Ticket #1 ************************************************** 
                 Ticket = -1; trycount = 0;         
                 while (Ticket == -1 && continue_trade == true){
                    RefreshRates(); 
                    if ( Trade_Type == "BSS" ) Ticket = OrderSend(Pairs_Ring[0],OP_BUY,lot1,NormalizeDouble(Ring1ASK,Digits),Slippage,0,0,EAName,Magic_Number,0,Red);   
                    if ( Trade_Type == "SBB" ) Ticket = OrderSend(Pairs_Ring[0],OP_SELL,lot1,NormalizeDouble(Ring1BID,Digits),Slippage,0,0,EAName,Magic_Number,0,Red);               
                    Error_Code = GetLastError();
                    //if (Error_Code == 136) EndEA();               
                    if (Error_Code == 136) Sleep_For_Hours(12);
                    if ( Trade_Type == "BSS" ) Ring1ASK = NormalizeDouble(MarketInfo(Pairs_Ring[0],MODE_ASK),Digits);
                    if ( Trade_Type == "SBB" ) Ring1BID = NormalizeDouble(MarketInfo(Pairs_Ring[0],MODE_BID),Digits);
                    //Print("Symbol = ", Pairs_Ring[0], "  Ring1BID = ", Ring1BID);                               
                    trycount++; 
                    Sleep( MathRound( (MathRand()/100) ) );
                    if (trycount > 9 && Ticket == -1) {
                       continue_trade = false;
                       break;
                    }
                 }
                 if ( Trade_Type == "BSS" ) Print("BSS BUY  Ticket1: ",Ticket," Ring1ASK: ",DoubleToStr(Ring1ASK,Digits)," Symbol: ",Pairs_Ring[0]," Spread: ",Ring1Spread," TryCount: ", trycount);
                 if ( Trade_Type == "SBB" ) Print("SBB SELL Ticket1: ",Ticket," Ring1BID: ",DoubleToStr(Ring1BID,Digits)," Symbol: ",Pairs_Ring[0]," Spread: ",Ring1Spread," TryCount: ", trycount);           
              
                 //************************************ Ticket #2 ************************************************** 
                 Ticket = -1; trycount = 0;         
                 while (Ticket == -1 && continue_trade == true){
                    RefreshRates();
                    if ( Trade_Type == "BSS" ) Ticket = OrderSend(Pairs_Ring[1],OP_SELL,lot2,NormalizeDouble(Ring2BID,Digits),Slippage,0,0,EAName,Magic_Number,0,Blue);   
                    if ( Trade_Type == "SBB" ) Ticket = OrderSend(Pairs_Ring[1],OP_BUY,lot2,NormalizeDouble(Ring2ASK,Digits),Slippage,0,0,EAName,Magic_Number,0,Blue);
                    Error_Code = GetLastError();
                    //if (Error_Code == 136) EndEA();               
                    if (Error_Code == 136) Sleep_For_Hours(12);
                    if ( Trade_Type == "BSS" ) Ring2ASK = NormalizeDouble(MarketInfo(Pairs_Ring[1],MODE_ASK),Digits);
                    if ( Trade_Type == "SBB" ) Ring2BID = NormalizeDouble(MarketInfo(Pairs_Ring[1],MODE_BID),Digits);
                    //Print("Symbol = ", Pairs_Ring[0], "  Ring1BID = ", Ring1BID);                               
                    trycount++; 
                    Sleep( MathRound( (MathRand()/100) ) );
                    if (trycount > 9 && Ticket == -1) {
                       continue_trade = false;
                       break;
                    }
                 }
                 if ( Trade_Type == "BSS" ) Print("BSS SELL Ticket2: ",Ticket," Ring2BID= ",DoubleToStr(Ring2BID,Digits)," Symbol: ",Pairs_Ring[1]," Spread: ", Ring2Spread," TryCount: ", trycount);          
                 if ( Trade_Type == "SBB" ) Print("SBB BUY  Ticket2: ",Ticket," Ring2ASK= ",DoubleToStr(Ring2ASK,Digits)," Symbol: ",Pairs_Ring[1]," Spread: ", Ring2Spread," TryCount: ", trycount);          
                   
                 //************************************ Ticket #3 ************************************************** 
                 Ticket = -1; trycount = 0;         
                 while (Ticket == -1 && continue_trade == true){
                    RefreshRates();
                    if ( Trade_Type == "BSS" ) Ticket = OrderSend(Pairs_Ring[2],OP_SELL,lot3,NormalizeDouble(Ring3BID,Digits),Slippage,0,0,EAName,Magic_Number,0,Blue);   
                    if ( Trade_Type == "SBB" ) Ticket = OrderSend(Pairs_Ring[2],OP_BUY,lot3,NormalizeDouble(Ring3ASK,Digits),Slippage,0,0,EAName,Magic_Number,0,Blue);
                    Error_Code = GetLastError();
                    //if (Error_Code == 136) EndEA();               
                    if (Error_Code == 136) Sleep_For_Hours(12);
                    if ( Trade_Type == "BSS" ) Ring3ASK = NormalizeDouble(MarketInfo(Pairs_Ring[2],MODE_ASK),Digits);
                    if ( Trade_Type == "SBB" ) Ring3BID = NormalizeDouble(MarketInfo(Pairs_Ring[2],MODE_BID),Digits);
                    //Print("Symbol = ", Pairs_Ring[0], "  Ring1BID = ", Ring1BID);                               
                    trycount++; 
                    Sleep( MathRound( (MathRand()/100) ) );
                    if (trycount > 9 && Ticket == -1) {
                       continue_trade = false;
                       break;
                    }
                 }
                 if ( Trade_Type == "BSS" ) Print("BSS SELL Ticket3: ",Ticket," Ring3BID= ",DoubleToStr(Ring3BID,Digits)," Symbol: ",Pairs_Ring[2]," Spread: ", Ring3Spread," TryCount: ", trycount);          
                 if ( Trade_Type == "SBB" ) Print("SBB BUY  Ticket3: ",Ticket," Ring3ASK= ",DoubleToStr(Ring3ASK,Digits)," Symbol: ",Pairs_Ring[2]," Spread: ", Ring3Spread," TryCount: ", trycount);          
              
                 if ( CountOrders(Magic_Number) == 3){
                    if ( Trade_Type == "BSS" ) Print(Stars," BSS DirectPrice: ",DoubleToStr(Ring1ASK,4),"  IndirectPrice: ",IndirectBID,"  Spread: ",Ring1Spread*Point,"  Misalignment: ",ArbitrageDifPips," FPI: ",FPI,"  ",Stars);
                    if ( Trade_Type == "SBB" ) Print(Stars," SBB DirectPrice: ",DoubleToStr(Ring1BID,4),"  IndirectPrice: ",IndirectASK,"  Spread: ",Ring1Spread*Point,"  Misalignment: ",ArbitrageDifPips," FPI: ",FPI,"  ",Stars);
                    Print ("(Ring2AVG:  ",Ring2AVG,"  Ring3AVG: ",Ring3AVG," (Ring2AVG * Ring3AVG)= ",(Ring2AVG * Ring3AVG));
                    Print ("ArbitrageDif = ", DoubleToStr(ArbitrageDif ,2),"  (Direct - Indirect): ",(Ring1AVG - IndirectAVG),"  Ring1AVG: ", Ring1AVG," IndirectAVG: ",IndirectAVG);
                 }  
                 RebuildRTA(); 
                 Print ("In Arbitrage: After Trade Unlocking...");
                 UnLockTrading(); 
                 Sleep(2000);                 
                 if (MathMod(OrdersTotal(),3) > 0){
                    if (CountOrders(Magic_Number) != 3){                    
                       Print ("NOT All 3 Trades Opened of Ring: " , Pairs_Ring[0], " ", Pairs_Ring[1], " ", Pairs_Ring[2]);
                       Print ("Number of Orders Opened: ", CountOrders(Magic_Number));
                       //CloseAllNonValidTrades();
                       CloseAllOpens(Magic_Number);
                       RebuildRTA();
                       Sleep_For_Hours(1); 
                    } 
                 }    
             }
          }
          if ( IsTradingLocked() == true) UnLockTrading();
      }
   } 
} 

// =========================================================================================== //
//                    C L O S E   A L L   O P E N    P O S I T I O N S                         //
// =========================================================================================== //
void CloseAllOpens(int Magic_Number){    
   bool answer1 = IsTradingLocked();
   int total = OrdersTotal();
    
   if ( answer1 == true){
      Print ("Trying to Close Orders but locked out...");
      Sleep (500);
   }
   if ( answer1 == false){
      Print ("In CloseOpenOrders: Attempt Lock...");
      if (LockTrading() == true){
         for(int i=total-1;i>=0;i--){
            OrderSelect(i, SELECT_BY_POS);
            int type   = OrderType();
            bool result = false;
            if(OrderMagicNumber()==Magic_Number){
                 switch(type)
                 {
                   //Close opened long positions
                   case OP_BUY       : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                                       break;
                   //Close opened short positions
                   case OP_SELL      : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                 }
            }
            if (result == false && (OrderMagicNumber()==Magic_Number))
            {
              Alert( OrderSymbol(), "  Order " , OrderTicket() , " MagicNum = ", OrderMagicNumber(), " failed to close. Error:" , GetLastError() );
              Sleep( MathRound( (MathRand()/200) ) );
            } 
            //if (result != false) RemoveTradeFrom_RTA(); 
         }

         //added 08022011                                
         RebuildRTA();
         Print ("In CloseOpenOrders: After Close Unlocking...");
         UnLockTrading();
      }
   }
}

// =========================================================================================== //
//                                return count of orders for given magic number                //
// =========================================================================================== //
int CountOrders(int Magic_Number){
   int Count = 0;
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      //if(OrderSymbol()==pairs[0] || OrderSymbol()==pairs[1]|| OrderSymbol()==pairs[0]){
         if((OrderType()==OP_BUY&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
         if((OrderType()==OP_BUYLIMIT&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
         if((OrderType()==OP_BUYSTOP&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
         if((OrderType()==OP_SELL&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
         if((OrderType()==OP_SELLLIMIT&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
         if((OrderType()==OP_SELLSTOP&&(OrderMagicNumber()==Magic_Number)||Magic_Number==0)) Count++;
      //}
   }
   return(Count);
}



// =========================================================================================== //
//                                Returns the profit of a ring trade                           //
// =========================================================================================== //
double Get_RTProfit(int MagicNum){
   double OrderTotalProfit = 0.0;
   for(int x=0;x<OrdersTotal();x++){
      OrderSelect(x,SELECT_BY_POS,MODE_TRADES);
      if ( OrderMagicNumber()== MagicNum ){
         OrderTotalProfit = OrderTotalProfit + OrderProfit(); 
         OrderTotalProfit = OrderTotalProfit + OrderCommission();
         OrderTotalProfit = OrderTotalProfit + OrderSwap();        
      }
   }
   //Print ("Magic #= ",MagicNum, " Profit = ", OrderTotalProfit );
   return (OrderTotalProfit);
}


// =========================================================================================== //
//                    D I S P L A Y   S T A T S   O N  T R A D I N G   S C R E E N             //
// =========================================================================================== //
void DisplayStats(){
   string Stars = "*****";
   string Line = "------------------------------------";
   string displaystr =  "\n" + "     |  " + EAName + "   Version: " + Version +  "   LiveTrades=" + LiveTrades + "   NFACompliance= " + NFACompliance + 
                        "  CurrentSymbolOnly= " + CurrentSymbolTrading + "   RunTime= " + StringSubstr(TimeToStr( (TimeCurrent()-RunTime),TIME_DATE | TIME_SECONDS),5,14)  +
                        "\n" + "     |  Rings Being Monitored: " + RingCount + "     |  Iterations: " + iterations + " mi: " + maintenance_iterations +
                        "\n" + "     |  Triggers:  LoFPI= " +  DoubleToStr(LoFPI,5) + "  | HiFPI= " + DoubleToStr(HiFPI,5) + "  |  Profit=$" + 
                        DoubleToStr(ProfitTrigger,2) + "  |  TrailStop %= " +DoubleToStr(TrailingStopPercentage,2)+ "  |  Hard Stop= $" + DoubleToStr(Hard_Profit_Stop,2) +
                        "\n" + "     |  FPILowest = " + DoubleToStr(FPILowest,5) + "  | FPIHighest= " + DoubleToStr(FPIHighest,5) + " |  FPI = " + DoubleToStr(FPI,5) + 
                        //"\n" + "     | FPI2Lowest = " + DoubleToStr(FPI2Lowest,5) + " |FPI2Highest =" + DoubleToStr(FPI2Highest,5) + " | FPI2 = " + DoubleToStr(FPI2,5) + " | ArbitrageDif= " + ArbitrageDif +  

                        //"\n" + "     |  BSS_FPI    =" + DoubleToStr(BSS_FPI ,5) +   "   SBB_FPI   =" + DoubleToStr(SBB_FPI ,5) +
                        "\n" + "     |  Total Ring Trades Open: " + ArrayRange(RTA,0) + 
                        "\n" + "     |  Total Current Open Orders: " + OrdersTotal();
   displaystr = displaystr +  "\n" + "     |" + Line + "\n" + "     |  AcctBalLowest = $" + DoubleToStr(AcctBalLowest,2) + 
   "   AcctBalHighest = $"+ DoubleToStr(AcctBalHighest,2) + "    CurrentProfit = $" + DoubleToStr(CurrentProfit,2);                      
   //displaystr = displaystr + "   Ring1DirectPrice = " + Ring1DirectPrice + "   Ring1BID= " + Ring1BID + "    Ring1Spread= " + Ring1Spread;
                       
   for (int i = 0;i < ArrayRange(RTA,0); i++){
        displaystr = displaystr + "\n" + "     |" + Line + "\n" +  "     |  " + "#" + i + "  " + DoubleToStr(RTA[i][0],0) +
        "    $"+DoubleToStr(RTA[i][1],2)+"    $"+DoubleToStr(RTA[i][2],2) + "    $" + DoubleToStr(Get_RTProfit(RTA[i][0]),2); 
   }
            
   Comment(displaystr); 
   
}

// =========================================================================================== //
//                        Generate Magic Number based on pairs ring                            //
// =========================================================================================== //
int GenerateMagicNumber(string Pairs_Ring[]){
   int mn = 0;
   string GenMagicNum = "987";
   for(int x=0;x<ArraySize(Pairs_Ring);x++){
      GenMagicNum = GenMagicNum + GetPairCode(Pairs_Ring[x]);
   }
   //Print ("the Magic Number for ", Pairs_Ring[0], Pairs_Ring[1], Pairs_Ring[2], " is ", GenMagicNum);
   mn = StrToInteger(GenMagicNum);
   return( mn); 
}


// =========================================================================================== //
//                        Return code for Magic Number based on pairs                          //
// =========================================================================================== //
string GetPairCode(string CurrencyPair){
   string code = "";
   if (CurrencyPair == "AUDCAD") code = "01";
   if (CurrencyPair == "AUDUSD") code = "02";
   if (CurrencyPair == "AUDNZD") code = "03";
   if (CurrencyPair == "AUDJPY") code = "04";
   if (CurrencyPair == "AUDCHF") code = "29";
   if (CurrencyPair == "AUDSGD") code = "30";
   
   if (CurrencyPair == "CADCHF") code = "22";
   if (CurrencyPair == "CADSGD") code = "31";
   if (CurrencyPair == "CHFSGD") code = "32"; 
   if (CurrencyPair == "CADJPY") code = "05";
   if (CurrencyPair == "CHFJPY") code = "06";
   
   if (CurrencyPair == "EURAUD") code = "07";
   if (CurrencyPair == "EURJPY") code = "08";
   if (CurrencyPair == "EURCAD") code = "09";
   if (CurrencyPair == "EURGBP") code = "10";
   if (CurrencyPair == "EURCHF") code = "11";
   if (CurrencyPair == "EURUSD") code = "18";    
   if (CurrencyPair == "EURNOK") code = "24";
   if (CurrencyPair == "EURSEK") code = "25";
   if (CurrencyPair == "EURSGD") code = "33";
   if (CurrencyPair == "EURTRY") code = "34";
   if (CurrencyPair == "EURDKK") code = "35";
   if (CurrencyPair == "EURPLN") code = "36";
   if (CurrencyPair == "EURHUF") code = "37";
   if (CurrencyPair == "EURNZD") code = "38";
      
   if (CurrencyPair == "GBPJPY") code = "12";
   if (CurrencyPair == "GBPCHF") code = "13";
   if (CurrencyPair == "GBPUSD") code = "19";
   if (CurrencyPair == "GBPAUD") code = "20";
   if (CurrencyPair == "GBPCAD") code = "23";
   if (CurrencyPair == "GBPNZD") code = "39";
   
   if (CurrencyPair == "NZDUSD") code = "14";
   if (CurrencyPair == "NZDCHF") code = "40";
   if (CurrencyPair == "NZDCAD") code = "41";
   if (CurrencyPair == "NZDSGD") code = "42";
   if (CurrencyPair == "NOKJPY") code = "43";
   if (CurrencyPair == "NZDJPY") code = "21";
   
   if (CurrencyPair == "USDDKK") code = "26";
   if (CurrencyPair == "USDNOK") code = "27";
   if (CurrencyPair == "USDJPY") code = "15";
   if (CurrencyPair == "USDCHF") code = "16";
   if (CurrencyPair == "USDCAD") code = "17";
   if (CurrencyPair == "USDHKD") code = "49";
   if (CurrencyPair == "USDHUF") code = "51";
   if (CurrencyPair == "USDSEK") code = "28"; 
   if (CurrencyPair == "USDSGD") code = "50";
   if (CurrencyPair == "USDTRY") code = "48";
   if (CurrencyPair == "USDZAR") code = "52";
   if (CurrencyPair == "USDMXN") code = "53";
   
   if (CurrencyPair == "SGDJPY") code = "44";
   if (CurrencyPair == "SEKJPY") code = "45";   
   
   if (CurrencyPair == "TRYJPY") code = "46";
   if (CurrencyPair == "ZARJPY") code = "47";
   
   return(code);
}


// =========================================================================================== //
//                        Creates array of Validated Currency Pairs                            //
// =========================================================================================== //
void CreateValidPairsArray(){
   string liststr;
   int PairsCount = Count_Pairs2(CurrencyPairs);
   //Print ("Pairs In Database:", PairsCount );
   ArrayResize(CurrencyPairs, PairsCount);
   
   //build valid list of currency pairs
   for(int x=0;x<PairsCount;x++){
      if (ValidatePair(CurrencyPairs[x]) == true){
         ArrayResize(ValidatedPairs, (ArraySize(ValidatedPairs)+1));
         ValidatedPairs[(ArraySize(ValidatedPairs)-1)] = CurrencyPairs[x];
      }   
   }
   for(x=0;x<ArraySize(ValidatedPairs);x++){
      liststr = liststr + ValidatedPairs[x] + ", ";
   }
   Print ("Number of Validated Pairs: ", x);
   Print ("Validated Pair List: ", liststr);
}

// =========================================================================================== //
//                   Validate Currency Trading Pairs for current trading platform              //
// =========================================================================================== //
bool ValidatePair(string CurrencyPair){
   double BidPrice = 0.0;
   //bool IsValid = true;
   BidPrice  = MarketInfo(CurrencyPair,MODE_BID);
   //Print ("BidPrice =  ", BidPrice );
   //if (BidPrice == 0.0) IsValid = false;
   bool IsValid = MarketInfo(CurrencyPair,MODE_TRADEALLOWED);
   if (IsValid){
      //Print (CurrencyPair," IsValid =", IsValid, " BidPrice =  ", BidPrice );
      //Print (RefreshRates());
   }
      
   return(IsValid);  
   
}


// =========================================================================================== //
//                           Creates array of Validated Pair Rings                             //
// =========================================================================================== //
void CreateRingArray(){
   string tmpstring[3];
   bool IsValid = false;
   bool MathValid = false;
   int count =0;
//3 nested loop
   int PairsCount = ArraySize(ValidatedPairs);

   for(int x=0;x<PairsCount;x++){
      for(int y=0;y<PairsCount;y++){
         for(int z=0;z<PairsCount;z++){
            tmpstring[0] =  ValidatedPairs[x];
            tmpstring[1] =  ValidatedPairs[y];
            tmpstring[2] =  ValidatedPairs[z];
            IsValid = ValidateRingOrder(tmpstring);
            MathValid = ValidateRingMath(tmpstring);
            if (IsValid == true && MathValid == true){
            //if (IsValid == true){
               count++;
               //Print ("tmpstring = ",tmpstring[0], " ", tmpstring[1], " ",tmpstring[2], "  Valid: ", IsValid , "  Math Valid: ", MathValid);
               ArrayResize(ValidatedRings, count);
               ValidatedRings[count-1][0] =  tmpstring[0];          
               ValidatedRings[count-1][1] =  tmpstring[1];
               ValidatedRings[count-1][2] =  tmpstring[2];  
               Print ("Ring Count = ", count , "  Validated Ring = ",  ValidatedRings[count-1][0], " ",   ValidatedRings[count-1][1], 
                     " ",  ValidatedRings[count-1][2], "  Valid: ", IsValid , "  Math Valid: ", MathValid);
               Sleep (100);
            }
         }  
      }
   }
   //Print ("(ArraySize(ValidatedRings) = ", ArrayRange(ValidatedRings,0),  " ring count = ", count);
}


// =========================================================================================== //
//                    Validates order of pairs in ring                                         //
// =========================================================================================== //
bool ValidateRingOrder(string ring_pairs[]){ 
   bool IsValid = true;
   string str1a = StringSubstr(ring_pairs[0], 0, 3);
   string str1b = StringSubstr(ring_pairs[0], 3, 3);
   string str2a = StringSubstr(ring_pairs[1], 0, 3);
   string str2b = StringSubstr(ring_pairs[1], 3, 3);
   string str3a = StringSubstr(ring_pairs[2], 0, 3);
   string str3b = StringSubstr(ring_pairs[2], 3, 3);

   if (CurrentSymbolTrading == false){ 
      //check for 1st currency in other pairs---must be in one of the other 2 pairs
      if (str1a != str2a) IsValid = false;
      if (str1b != str3b) IsValid = false;
      if (str2b != str3a) IsValid = false;  
   }
   //if (IsValid == true) Print ("ring is valid");
   if (CurrentSymbolTrading == true){ 
     if (ring_pairs[0] != Symbol()) IsValid = false;
     if (str1a != str2a) IsValid = false;
     if (str1b != str3b) IsValid = false;
     if (str2b != str3a) IsValid = false;  
   }
   return (IsValid);
}


// =========================================================================================== //
//                                 Validates 2 pairs = 1 pair                                  //
// =========================================================================================== //
bool ValidateRingMath(string ring_pairs[]){  
   bool IsValid = false;
   double price1 = MarketInfo(ring_pairs[0],MODE_BID);
   double price2 = MarketInfo(ring_pairs[1],MODE_BID);
   double price3 = MarketInfo(ring_pairs[2],MODE_BID); 
   if ( (price1 - (price2*price3) < 0.1) && (price1 - (price2*price3) > -0.1) ) IsValid = true;
   //if (IsValid == true){
   //    Print ("MATH on ring is valid: ", (price1 - (price2*price3)));
   //}
   return (IsValid);
}

// =========================================================================================== //
//                   Closes all trades rings that have less than 3 trades open                 //
// =========================================================================================== //
// this needs work as of 8/1/2011.. Closing trades as it opens them because < 3 trades until all trade are open... 
void CloseAllNonValidTrades(){
   for(int x=0;x<ArrayRange(RTA,0);x++){
      if (CurrentSymbolTrading == true) {
         if ( (CountOrders(RTA[x][0]) != 3) &&  (OkToClose(RTA[x][0]) == True) ){
            
            if (InvalidTradeTime != -1){
               if (TimeCurrent() - InvalidTradeTime > 5){ // ten seconds after first detected close invalid trades
                  Print ("Closing all invalid trades...");
                  CloseAllOpens(RTA[x][0]);
                  InvalidTradeTime = -1; //reset 
               }
            }
            if (InvalidTradeTime == -1){
               InvalidTradeTime = TimeCurrent();
               Print ("Invalid Trades found with MN: ", RTA[x][0], "  Number of open trades: ", CountOrders(RTA[x][0]), "  Going to close them in 5 seconds...");
               Sleep (1100);
            }
         }
      }
      if (CurrentSymbolTrading == false) {
         if ( (CountOrders(RTA[x][0]) != 3) ){
            
            if (InvalidTradeTime != -1){
               //Print ("Time to close Invalid Trades: ", (10 - (TimeCurrent() - InvalidTradeTime)));
               if (TimeCurrent() - InvalidTradeTime > 5){ // ten seconds after first detected close invalid trades
                  Print ("Closing all invalid trades...");
                  CloseAllOpens(RTA[x][0]);
                  InvalidTradeTime = -1; //reset 
               }
            }
            if (InvalidTradeTime == -1){
               InvalidTradeTime = TimeCurrent();
               Print ("Invalid Trades found with MN: ", RTA[x][0], "  Number of open trades: ", CountOrders(RTA[x][0]), "  Going to close them in 5 seconds...");
               Sleep (1100);
            }
         }
      }
      
   }
}

// =========================================================================================== //
//                    Emergency Close ALL open trade                                           //
// =========================================================================================== //
void EmergencyCloseAllTrades(){
   if (OrdersTotal() > 0){
      Print ("inside emergency", OrdersTotal());
      for(int x=0;x<OrdersTotal();x++){
         OrderSelect(x,SELECT_BY_POS,MODE_TRADES);
         CloseAllOpens(OrderMagicNumber());
      }
      DisplayStats();
   }
}


// =========================================================================================== //
//                   NFA Rule Compliance Check                                                 //
// =========================================================================================== //
bool NFACheck(string local_ring[]){
   int totalorders = OrdersTotal();
   bool OkToTrade = true;
   string Order_Symbol = ""; 
   if (NFACompliance == false) OkToTrade = true;
   if (NFACompliance == true){
      for(int i=0;i<totalorders;i++){
         OrderSelect(i, SELECT_BY_POS);
         for(int x=0;x<3;x++){
            if (local_ring[x] == OrderSymbol()){
               OkToTrade = false;
               Print("NFA Violation...Cannot Trade Ring: ", local_ring[0], " ", local_ring[1], " ", local_ring[2]);
            }
         } 
      }
   }
   return(OkToTrade);
}

void RemoveTradeFrom_RTA(){
   int temptable[][3];
   int tempcount =0;
   
   Print ("Before RemoveTradeFrom_RTA Table: ArrayRange(RTA,0) = ", ArrayRange(RTA,0));
   for(int x=0;x<(ArrayRange(RTA,0));x++){
      tempcount = CountOrders(RTA[x][0]);
      if (tempcount < 3 ){
         RTA[x][0] = -1;
         RTA[x][1] = -1;
         RTA[x][2] = -1;     
      }   
      tempcount = 0;
   }
   
   for(x=0;x<(ArrayRange(RTA,0));x++){
      if (RTA[x][0] != -1){
         ArrayResize(temptable, (ArrayRange(temptable,0)+1));
         temptable[x-1][0] =  RTA[x][0];
         temptable[x-1][1] =  RTA[x][1];
         temptable[x-1][2] =  RTA[x][2];        
      }    
   }
   ArrayResize(RTA,0);
   for(x=0;x<ArrayRange(temptable,0);x++){
      if (temptable[x][0] != -1){
         ArrayResize(RTA, (ArrayRange(RTA,0)+1));
         RTA[x-1][0] =  temptable[x][0];
         RTA[x-1][1] =  temptable[x][1];
         RTA[x-1][2] =  temptable[x][2];         
      }    
   }
   Print ("After RemoveTradeFrom_RTA Table: ArrayRange(RTA,0) = ", ArrayRange(RTA,0));
}


void RebuildRTA(){
   //Print ("Rebuilding RTA...");
   int Count = 0;
   int AllMagicNumbers[];
   int AllTradeDates[];
   int OrdersCount = OrdersTotal();
   bool Found = false;
   ArrayResize(AllMagicNumbers, OrdersCount);
   ArrayResize(AllTradeDates, OrdersCount);
   ArrayResize(RTA,0); 
   //Print ("Total open orders = ", OrdersCount);
   //put all magic numbers into an Array  
   if (OrdersCount > 0){
      for(int i=0;i<OrdersCount;i++){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         AllMagicNumbers[i] = OrderMagicNumber();
         AllTradeDates[i] = OrderOpenTime();
      } 
      //ArraySort(AllMagicNumbers);
      //ArraySort(AllTradeDates,WHOLE_ARRAY,0,MODE_DESCEND);
     
      for(i=0;i<OrdersCount;i++){
         Found = false;
         for(int x=0;x<ArrayRange(RTA,0);x++){
            if (AllMagicNumbers[i] == RTA[x][0]){
               Found = true;
            }
         }
         if (Found == false){              
            AddTradeTo_RTA(AllMagicNumbers[i]);
         }
      } 

   }

   //Print ("After Rebuild RTP Table: ArrayRange(RTA,0) = ", ArrayRange(RTA,0));
}

/*
// =========================================================================================== //
//                    U P D A T E   S I N G L E   O P E N   R I N G   T R A D E   P R O F I T S      //
// =========================================================================================== //
void Update_Single_RTA_Profits(int local_mn){
   bool found = false;
   double local_currentprofit = 0.0;  
   for (int x = 0;x < ArrayRange(RTA,0); x++){
         local_currentprofit = Get_RTProfit(RTA[x][0]);
         if (local_currentprofit > RTA[x][2]){
            //Print ("New HIGH Profit for trade: ", RTA[x][0], "  Profit: $", local_currentprofit);
            RTA[x][2] = local_currentprofit;
         }
         if (local_currentprofit < RTA[x][1]){
            RTA[x][1] = local_currentprofit;
            //Print ("New LOW Profit for trade: ", RTA[x][0], "  Profit: $", local_currentprofit);
         }           
   }         
}

*/

// =========================================================================================== //
//                    U P D A T E   A L L   O P E N   R I N G   T R A D E   P R O F I T S      //
// =========================================================================================== //
void Update_All_RTA_Profits(){
   bool found = false;
   double local_currentprofit = 0.0;  
   for (int x = 0;x < ArrayRange(RTA,0); x++){
         local_currentprofit = Get_RTProfit(RTA[x][0]);
         if (local_currentprofit > RTA[x][2]){
           // Print ("New HIGH Profit for trade: ", RTA[x][0], "  Profit: $", local_currentprofit);
            RTA[x][2] = local_currentprofit;
         }
         if (local_currentprofit < RTA[x][1]){
            RTA[x][1] = local_currentprofit;
            //Print ("New LOW Profit for trade: ", RTA[x][0], "  Profit: $", local_currentprofit);
         }           
   }  
        
}

// =========================================================================================== //
//                           A D D  T R A D E  T O  R T A                                      //
// =========================================================================================== //
void AddTradeTo_RTA(int local_mn){
   ArrayResize(RTA, (ArrayRange(RTA,0)+1));
   int index = ArrayRange(RTA,0);
   double cp = Get_RTProfit(local_mn);          
   RTA[(index-1)][0] = local_mn;
   RTA[(index-1)][1] = cp;
   RTA[(index-1)][2] = cp;
   //for (int x = 0;x < ArrayRange(RTA,0); x++){
   //   Print ("inside AddTradeTo_RTA: RTA[", x, "][0] = ",RTA[x][0]);
  // }
}


// =========================================================================================== //
//                 C H E C K  I F  O K  T O  C L O S E  A  R I N G  T R A D E                  //
// =========================================================================================== //
bool OkToClose(int local_mn){
   bool answer = false;
   string code1 = StringConcatenate("",local_mn);
   //Print ("code1 now= ", code1);
   code1 = StringSubstr(code1, 3, 2);
   string code2 = GetPairCode(Symbol());
   
   //Print ("Symbol = ", Symbol(), "  MN = ", local_mn, " code1 = ", code1, "  code2 = ", code2);
   if (code1 == code2) answer = true;
   if (code1 == "") answer = true; // to handle trades with no magic number
   
   return (answer);
}

// =========================================================================================== //
//                 CHECK IF ENOUGH FUNDS AVAILABLE TO MAKE TRADE                               //
// =========================================================================================== //
//must always be called after calculate_lots is called
bool Enough_Funds_To_Trade(){
   bool answer = true;
   double Total_Lots = lot1 + lot2 +lot3;
   double FreeMarginAfterTrade = AccountFreeMarginCheck(Symbol(),OP_BUY,Total_Lots);
   
   //if (TradeType == "BSS"){
   Print("Funds available after trade: ", FreeMarginAfterTrade);
   if( (FreeMarginAfterTrade <=0) || GetLastError()==134) answer = false;
  // }
   
   //if (TradeType == "SBB"){
   //   if(AccountFreeMarginCheck(Symbol(),OP_SELL,Total_Lots)<=0 || GetLastError()==134) answer = false;
   //}  

   if (answer == false){
      Print("Not enough funds to make trade... Free Margin= ", AccountFreeMargin());
     }
   return (answer);
}

// =========================================================================================== //
//                                 Check for Hard Profit Stop                                       //
// =========================================================================================== //
//if a trade hits hard profit trigger close it
void Check_Hard_Profit_Stop(int local_mn){
   double  local_currentprofit = Get_RTProfit(local_mn);
  // ringcount has to be == 3
   if (local_currentprofit > Hard_Profit_Stop){
      //trade is now above hard profit stop. closing trade
      Print ("Hard Profit Stop... Closing trades on RingTrade: ", local_mn, "  CurrentProfit = $", local_currentprofit,"  Hard Stop = $", Hard_Profit_Stop);
      CloseAllOpens(local_mn);
   }
}


// =========================================================================================== //
//                                 Monitor Trailing Stop                                       //
// =========================================================================================== //
//once a trade becomes profitable track trailer stop
//if profit slips by XX% close out all trades.
void MonitorTrailingStop(int local_MagicNum){
   double Threshold = 0.0;
   double tmp =0.0;
   double local_CurrentProfit = Get_RTProfit(local_MagicNum);
   double local_HighProfit    = Get_RT_High_Profit(local_MagicNum);
   int    local_RTA_index     = Get_RTA_Index(local_MagicNum);
   //added below on 6/27/2011 - to reset high profit if hits trigger then 
   //drops back below trigger point. That way if it jumps back above trigger point 
   // it doesnt just close trade immediately 
   if ( (local_HighProfit > ProfitTrigger) && (local_CurrentProfit < 0.0) ){
      Print ("ProfitTrigger reached but price back under trigger point: Resettting High Profit...");
      Print ("Trade: ", local_MagicNum, "  ProfitTrigger: ", ProfitTrigger, "  High Profit: ",local_HighProfit, "  Current Profit: ", local_CurrentProfit);
      RTA[local_RTA_index][2] = 0.0;
   } 
   //if (local_MagicNum == 987155247 ) Print ("RingTrade: ", local_MagicNum,"   HighProfit: $", RTA[local_RTA_index][2], "  CurrentProfit = $", local_CurrentProfit, "  StopLoss = $", Threshold);
 
   if (local_CurrentProfit > ProfitTrigger){
      tmp = (1.0 - (TrailingStopPercentage/100.0));
      Threshold = (RTA[local_RTA_index][2]) * tmp;
      //Print ("RingTrade: ", local_MagicNum,"   HighProfit: $", RTA[local_RTA_index][2], "  CurrentProfit = $", local_CurrentProfit, "  StopLoss = $", Threshold);
 
      if (local_CurrentProfit > RTA[local_RTA_index][2]){
         Print ("RingTrade: ", local_MagicNum,"   HighProfit: $", RTA[local_RTA_index][2], "  CurrentProfit = $", local_CurrentProfit, "  StopLoss = $", Threshold);
      }
      if (local_CurrentProfit < Threshold){
         //trade is now above trigger profit point and has reveresed enough to trigger close out
         Print ("Stoploss hit. Closing trades on RingTrade: ", local_MagicNum, "  CurrentProfit = $", local_CurrentProfit, "  HighProfit: $", RTA[local_RTA_index][2], "  StopLoss= $", Threshold);
         CloseAllOpens(local_MagicNum);
      }
   }      
}


// =========================================================================================== //
//                                 Get High Profit                                       //
// =========================================================================================== //
//returns high_profit for a give magic number 
double Get_RT_High_Profit(int local_MagicNum){
   double answer = 0.0;
   for (int x = 0;x < ArrayRange(RTA,0); x++){
      if (RTA[x][0] == local_MagicNum){
         answer = RTA[x][2];
      }
   }
   return (answer);
}

// =========================================================================================== //
//                                 Get RTA Index for a given Magic Number                                       //
// =========================================================================================== //
//returns the index to RTA for a give magic number 
int Get_RTA_Index(int local_MagicNum){
   double answer = -1;
   for (int x = 0;x < ArrayRange(RTA,0); x++){
      if (RTA[x][0] == local_MagicNum){
         answer = x;
       }
   }
   return (answer);
}

// =========================================================================================== //
//                                 Lock trading                                             //
// =========================================================================================== //
//lock trading so only one symbol is trying to trade at any given Point
bool LockTrading(){
   bool answer = false;
   int handle;
   int value=1;
   int fsize = 0;
   int attempts = 0;
   Print ("In LockTrading: Waiting for tradelock...", TimeCurrent());
   while ( answer == false && attempts < 10){
      // Text     =FileReadString(Handle);// Text of event description
      // Symbol() 
      handle=FileOpen("tradinglock.dat", FILE_BIN|FILE_READ|FILE_WRITE);
      Print ("in LockTrading: file handle=", handle);
      if(handle<1){
         Print("in LockTrading: cant get file handle with error- ",GetLastError());
      }
      if ( handle > 1 ){
         FileClose(handle);
         answer = false;
      }
      if ( handle == 1 ){
         fsize = FileSize(handle);
         //Print ("filesize = ", fsize );
         if (fsize  == 0 ){
            FileWriteString(handle, Symbol(), StringLen(Symbol()));
            //FileWriteInteger(handle, value, SHORT_VALUE);
            Print ("In LockTrading: Trading allowed for ", Symbol(), " ....Tradelock established...", TimeCurrent());
            FileClose(handle);
            answer = true;
         }
         if (fsize  != 0 ){
            //Print ("trading locked...NO TRADES ALLOWED!");
            FileClose(handle);
         }
      }
      Sleep( MathRound( (MathRand()/100) ) );
      attempts++;
   }
      
   if (answer == false ) Print ("in LockTrading: Tradelock NOT established...", TimeCurrent());
   //if (handle > 0 ) FileClose(handle);
   return (answer);
}




// =========================================================================================== //
//                                 Unlock trading                                             //
// =========================================================================================== //
//lock trading so only one symbol is trying to trade at any given Point
void UnLockTrading(){
   bool answer = IsTradingLocked();
   
   if ( answer == true ){
      Print ("Unlocking trading...");
      FileDelete("tradinglock.dat");
   }
   if ( answer == false ){
      Print ("Failed to Unlock trading...trading not locked");
   }  
}


// =========================================================================================== //
//                                 Is trading Locked                                            //
// =========================================================================================== //
//lock trading so only one symbol is trying to trade at any given Point
bool IsTradingLocked(){
   bool answer = false;
   int handle;
   int value=1;
   int fsize = 0;
   handle=FileOpen("tradinglock.dat", FILE_BIN|FILE_READ);
   //Print ("file handle=", handle);
   if( handle < 1){
      Print("Trading Lock File not found..Trading Unlocked debug: ",GetLastError());
   }
   if(handle > 0){
      fsize = FileSize(handle);
      //Print ("filesize = ", fsize );
      if (fsize  != 0 ){
         FileSeek(handle, 0, SEEK_SET);
         string txt = FileReadString(handle, StringLen(Symbol()));
         if (txt == Symbol() ){
            Print ("trading locked by THIS EA.");
            answer = true;
         }
         if (txt != Symbol() ){
            Print ("trading locked By ANOTHER EA: ", txt);
         }         
      }
   }
   if( handle > 0) FileClose(handle);
   return(answer);
}

// =========================================================================================== //
//                                 TERMINATE EA                                           //
// =========================================================================================== //
//this functions called to terminate the EA
void EndEA(){
   int kkk = 10;
   Print ("Terminating EA..", GetLastError());
   UnLockTrading();
   CloseAllNonValidTrades();
   if (kkk == 10) kkk /= 0;
}

// =========================================================================================== //
//                                 Sleep for hours                                         //
// =========================================================================================== //
//this functions Sleep for hours 
void Sleep_For_Hours(int hourstosleep){
   UnLockTrading();
   CloseAllNonValidTrades();
   Print ("EA ", Symbol(), " going to sleep for ", hourstosleep, " hours.");
   for (int x = 0; x < hourstosleep; x++){
      UnLockTrading();
      CloseAllNonValidTrades();
      Sleep(3600000);
      Print ("EA ", Symbol(), " has been sleeping for ", x, " hours."); 
   }
}