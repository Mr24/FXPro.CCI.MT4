//+------------------------------------------------------------------+
//|                        		 VerysVeryInc.MetaTrader4.FX.CCI.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                          CCI.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
//|                                               DoublecciWoody.mq4 |
//|                http://www.abysse.co.jp/mt4/indicator_name_d.html |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_CCI - Ver.0.12.0.3  Update:2018.01.17"
#property strict

//--- Includes ---//
// #include <MovingAverages.mqh>

//--- CCI : Initial Setup ---//
#property indicator_separate_window
#property indicator_buffers 7

//--- CCI : Color Setup ---//
#property indicator_color1 LightSeaGreen
#property indicator_color2 White
#property indicator_color3 Gold
/*
#property indicator_color1 MediumSeaGreen //Green
#property indicator_color2 Red            //SaddleBrown
#property indicator_color3 DarkGray
#property indicator_color4 Gold
#property indicator_color5 DarkKhaki      //White
#property indicator_color6 White          //Magenta
#property indicator_color7 DarkKhaki
*/

//--- CCI : Level Setup ---//
#property indicator_level1 350
#property indicator_level2 250
#property indicator_level3 100
#property indicator_level4 0
#property indicator_level5 -100
#property indicator_level6 -250
#property indicator_level7 -350
//#property indicator_level8 -50
/* (0.12.0.1.OK)
#property indicator_level1    -100.0
#property indicator_level2     100.0
*/

//--- CCI : Level Color Setup ---//
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

//--- CCI : Parameter
extern int TrendCCI_Period = 14;
extern int EntryCCI_Period = 6;
// (0.12.0.1.OK) extern int Trend_period = 2;
// extern int CountBars = 1440;

//--- CCI : Buffer ---//
double TrendCCI[];
double EntryCCI[];
double ZeroLine[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.12.0.1)          |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- 1. Trend.CCI : Indicators
	//--- 3 Addtional Buffer Used for Conting.
	IndicatorBuffers( 3 );

	//*--- Check for Input Parameter
	if(TrendCCI_Period <= 1)
	{
		Print("Wrong input parameter CCI Period=", TrendCCI_Period);
		return(INIT_FAILED);
	}

	//*--- Trend.CCI Buffer
	SetIndexDrawBegin( 0, TrendCCI_Period );
	SetIndexStyle( 0, DRAW_LINE, STYLE_SOLID, 1 );
	SetIndexBuffer( 0, TrendCCI );

	//*--- Entry.CCI Buffer
	SetIndexDrawBegin( 1, TrendCCI_Period );
	SetIndexStyle( 1, DRAW_LINE, STYLE_SOLID, 1 );
	SetIndexBuffer( 1, EntryCCI );

	//*--- ZeroLine Buffer
	SetIndexDrawBegin( 2, TrendCCI_Period );
	SetIndexStyle( 2, DRAW_LINE, STYLE_SOLID, 1 );
	SetIndexBuffer( 2, ZeroLine );
	
	//*--- Trend.CCI Lavel
	string short_name;
	short_name = "Trend.CCI(" + IntegerToString(TrendCCI_Period)
			+ "),Entry.CCI(" + IntegerToString(EntryCCI_Period) + ")";
	IndicatorShortName( short_name );
	SetIndexLabel( 0, short_name );

//--- Initialization Done
  return(INIT_SUCCEEDED);

}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.12.0.1)        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}

//***//


//+------------------------------------------------------------------+
//| CCI Bands (Ver.0.12.0.1) 	 									 |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//--- 1. Trend.CCI : Caluculate.Setup
/*
	int counted_bars = IndicatorCounted();

	//--- Check for Possible errors
	if(counted_bars<0) return(-1);
	if(counted_bars>0) counted_bars--;
*/

	//--- Draw Begin Setup
	// SetIndexDrawBegin( 0, Bars - CountBars );

	//--- CCI Counting
	int limit = Bars;
	for( int i=limit-1; i>=0; i-- )
	{
		TrendCCI[i] = iCCI( NULL, 0, TrendCCI_Period, PRICE_TYPICAL, i );
		EntryCCI[i] = iCCI( NULL, 0, EntryCCI_Period, PRICE_TYPICAL, i );
		ZeroLine[i] = 0;
	}
	/* (Ver.0.12.0.1.OK)
		for( int i=limit-1; i>=0; i-- )
			TrendCCI[i] = iCCI( NULL, 0, TrendCCI_Period, PRICE_TYPICAL, i );
	*/

//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);

}

//+------------------------------------------------------------------+