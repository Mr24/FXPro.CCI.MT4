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
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_CCI - Ver.0.12.0.1  Update:2018.01.16"
#property strict

//--- Includes ---//
// #include <MovingAverages.mqh>

//--- CCI : Initial Setup ---//
#property indicator_separate_window
#property indicator_buffers 1

//--- CCI : Color Setup ---//
#property indicator_color1 LightSeaGreen

//--- CCI : Level Setup ---//
#property indicator_level1    -100.0
#property indicator_level2     100.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

//--- CCI : Parameter
extern int TrendCCI_Period = 14;
extern int Trend_period = 2;
// extern int CountBars = 1000;

//--- CCI : Buffer ---//
double TrendCCI[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.12.0.1)          |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- 1. Trend.CCI : Indicators
	//--- 1 Addtional Buffer Used for Conting.
	IndicatorBuffers( 1 );

	//*--- Check for Input Parameter
	if(TrendCCI_Period <= 1)
	{
		Print("Wrong input parameter CCI Period=", TrendCCI_Period);
		return(INIT_FAILED);
	}

	//*--- Trend.CCI Buffer
	SetIndexDrawBegin( 0, TrendCCI_Period );
	SetIndexStyle( 0, DRAW_LINE, STYLE_SOLID, 2 );
	SetIndexBuffer( 0, TrendCCI );
	
	//*--- Trend.CCI Lavel
	string short_name;
	short_name = "Trend.CCI(" + IntegerToString(TrendCCI_Period)+")";
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
			TrendCCI[i] = iCCI( NULL, 0, TrendCCI_Period, PRICE_TYPICAL, i );


//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);

}

//+------------------------------------------------------------------+