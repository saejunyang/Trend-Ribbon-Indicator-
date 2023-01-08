//+------------------------------------------------------------------+
//|                                                 Trend Ribbon.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2 

input    int            SignalMAPeriod = 5;    
input    int            FastMAPeriod   = 13;
input    int            SlowMAPeriod   = 34;
input    ENUM_MA_METHOD MAMethod       = MODE_EMA;

double   BufferFast[];
double   BufferSlow[];

#define  FastIndicator 0
#define  SlowIndicator 1 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   SetIndexStyle(FastIndicator,DRAW_LINE,STYLE_DOT, 1, clrBlueViolet);
   SetIndexBuffer(FastIndicator,BufferFast);
   SetIndexLabel(FastIndicator,"Fast");

   SetIndexStyle(SlowIndicator,DRAW_LINE,STYLE_DOT, 1, clrCrimson);
   SetIndexBuffer(SlowIndicator,BufferSlow);
   SetIndexLabel(SlowIndicator,"Slow");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---
   int      limit;
   double   signalMa,
            fastMa,
            slowMa;
   if(rates_total <= SlowMAPeriod)
      return (0);
      
   limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit++;
      
   for(int i=limit-1; i>=0; i--)
   {
      signalMa=iMA(Symbol(), Period(), SignalMAPeriod, 0, MAMethod, PRICE_CLOSE, i);
      fastMa=iMA(Symbol(), Period(), FastMAPeriod, 0, MAMethod, PRICE_CLOSE, i);
      slowMa=iMA(Symbol(), Period(), SlowMAPeriod, 0, MAMethod, PRICE_CLOSE, i);
          
      if (signalMa>fastMa && fastMa>slowMa)
      {
         BufferFast[i]=fastMa;
         BufferSlow[i]=slowMa;
      }
      else if (signalMa<fastMa && fastMa<slowMa)
      {
         BufferFast[i]=fastMa;
         BufferSlow[i]=slowMa; 
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
