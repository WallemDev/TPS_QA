class QuotesController < ApplicationController
  require 'will_paginate/array'
  #require 'nokogiri'
  @@common_sql = "SELECT [dbMPE].[dbo].[tblWSQuoteHdr].[intID] , [dbMPE].[dbo].[tblWSQuoteHdr].[strQuotesNo]
  ,[dbMPE].[dbo].[tblWSQuoteHdr].[intQteVerNo],[dbMPE].[dbo].[tblWSQuoteHdr].[strRQNo]
        ,[dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated],[dbMPE].[dbo].[tblWSQuoteHdr].[dteUpdated]
  ,[dbMPE].[dbo].[tblWSQuoteHdr].[strSupRemark], [dbMPE].[dbo].[tblWSQuoteHdr].[strSupRefNo]
      ,[dbMPE].[dbo].[tblVesselInfo].strVslName
  ,[dbMPEMultiparty].[dbo].[tblSuppliers].strCompName
  ,[dbMPE].[dbo].[tblRQHeader].strEqptTitle
    FROM [dbMPE].[dbo].[tblWSQuoteHdr] LEFT JOIN [dbMPE].[dbo].[tblVesselInfo] ON
      [dbMPE].[dbo].[tblWSQuoteHdr].strBuyRMSTPID = [dbMPE].[dbo].[tblVesselInfo].strRMSTPID
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strIMONo = [dbMPE].[dbo].[tblVesselInfo].strIMONo
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strVslCode = [dbMPE].[dbo].[tblVesselInfo].strVslCode
    LEFT JOIN [dbMPEMultiparty].[dbo].[tblSuppliers] ON
     [dbMPE].[dbo].[tblWSQuoteHdr] .strBuyRMSTPID = [dbMPEMultiparty].[dbo].[tblSuppliers].strBuyRMSTPID
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strRMSTPID = [dbMPEMultiparty].[dbo].[tblSuppliers].strRMSTPID
    LEFT JOIN [dbMPE].[dbo].[tblRQHeader] ON
     [dbMPE].[dbo].[tblWSQuoteHdr].strBuyRMSTPID = [dbMPE].[dbo].[tblRQHeader].strBuyRMSTPID
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strIMONo = [dbMPE].[dbo].[tblRQHeader].strIMONo
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strVslCode = [dbMPE].[dbo].[tblRQHeader].strVslCode
 AND [dbMPE].[dbo].[tblWSQuoteHdr].strRQNo = [dbMPE].[dbo].[tblRQHeader].strRQNo"

  def show
    # get page number
    page = params[:page]
    is_partial = params[:is_partial]

    if page.nil?
      page = 1
    end
    row_per_page = 10
    #sql = "SELECT  *
    #        FROM [dbMPE].[dbo].[tblWSQuoteHdr]
    #        WHERE YEAR(dteCreated) =   YEAR(GETDATE())
    #        AND   MONTH(dteCreated) =   MONTH(GETDATE())
    #        ORDER BY [dteCreated] DESC";
    sql = @@common_sql
    sql =sql + " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
          AND   MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   MONTH(GETDATE())
          ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC"

    LoggerHelper.log_info('quote.log', sql, __FILE__, __LINE__)
    #@quotes = Quotes.find_by_sql(sql)
    begin
      @quotes = SqlHelper.select_all('development', sql)
      @quotes = @quotes.paginate(:page => page, :per_page => row_per_page)
    rescue => ex
      LoggerHelper.log_error('quote.log', ex.to_s, __FILE__, __LINE__)
    end

    if !is_partial
      render 'quotes/index'
    else
      #render :partial => 'search_quotes'
      render :partial => 'search_quotes_ver2'
      LoggerHelper.log_info('quote.log', 'Success', __FILE__, __LINE__)
    end
  end

  def show_search_result

  end

  def index

  end

  def reload_quote_details
    @quote_details = []
    render :partial => 'quote_details/quotes_details_ver2'
  end
  # search quotes
  def search_quotes
    page = params[:page]
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @filter_by = params[:filter_by]
    @str_search = params[:str_search]
    if page.nil?
      page = 1
    end
    row_per_page = 10
    time = Time.now
    month = time.month
    #cmsam standalize the search string
    single_quote = '\''
    double_quote = '\'\''
    if @str_search.include? single_quote
      @str_search.gsub! single_quote, double_quote
    end
    @search_and = " AND ([dbMPE].[dbo].[tblVesselInfo].strVslName LIKE '%"+@str_search+"%' OR [dbMPE].[dbo].[tblWSQuoteHdr].[strRQNo] LIKE '%"+@str_search+"%'
           OR [dbMPEMultiparty].[dbo].[tblSuppliers].strCompName LIKE '%"+@str_search+"%' OR [dbMPE].[dbo].[tblRQHeader].strEqptTitle LIKE '%"+@str_search+"%' )
      ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC"
    if (@str_search!="")
      if (@from_date!="" && @to_date!="")
        #sql = "SELECT DISTINCT  * FROM tblWSQuoteHdr
        #      WHERE  CONVERT(DATETIME,[dteCreated])<= CONVERT(DATETIME,'"+@to_date+"')+1
        #      AND    CONVERT(DATETIME,[dteCreated])>= CONVERT(DATETIME,'"+@from_date+"')
        #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
        #      ORDER BY dteCreated DESC";
        sql = @@common_sql
        sql = sql+  " WHERE  CONVERT(DATETIME,[dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated])<= CONVERT(DATETIME,'"+@to_date+"')+1
              AND    CONVERT(DATETIME,[dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated])>= CONVERT(DATETIME,'"+@from_date+"')" + @search_and
      else
        if (@filter_by!="")
          #select data current month & remark
          if @filter_by=='Current Month'
            #sql = "SELECT    *
            #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
            #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
            #      AND   MONTH(dteCreated) =   MONTH(GETDATE())
            #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
            #      ORDER BY [dteCreated] DESC";
            sql = @@common_sql
            sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
            AND   MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   MONTH(GETDATE()) "+@search_and
            #select data current quarter & remark
          elsif @filter_by=='Current Quarter'
            time = Time.now
            month = time.month
            if (month <=3 && month>=1)
              #sql = "SELECT    *
              #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
              #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
              #      AND  ( MONTH(dteCreated) >=1 AND MONTH(dteCreated) <=3)
              #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
              #      ORDER BY [dteCreated] DESC";
              sql = @@common_sql
              sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
              AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=1 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=3)"+@search_and
            elsif (month <=6 && month>=4)
              #sql = "SELECT  *
              #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
              #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
              #      AND  ( MONTH(dteCreated) >=4 AND MONTH(dteCreated) <=6)
              #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
              #      ORDER BY [dteCreated] DESC";
              sql = @@common_sql
              sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
                    AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=4 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=6)" +@search_and
            elsif (month <=9 && month >=7)
              #sql = "SELECT    *
              #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
              #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
              #      AND  ( MONTH(dteCreated) >=7 AND MONTH(dteCreated) <=9)
              #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
              #      ORDER BY [dteCreated] DESC";
              sql = @@common_sql
              sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
                    AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=7 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=9)" +@search_and
            elsif (month <=12 && month >=10)
              #sql = "SELECT    *
              #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
              #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
              #      AND  ( MONTH(dteCreated) >=10 AND MONTH(dteCreated) <=12)
              #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
              #      ORDER BY [dteCreated] DESC";
              sql =@@common_sql
              sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
                    AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=10 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=12)" +@search_and
            end
            #select data current year & remark
          elsif @filter_by=='Current Year'
            #sql = "SELECT    *
            #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
            #      WHERE YEAR(dteCreated) = YEAR(GETDATE())
            #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
            #      ORDER BY [dteCreated] DESC";
            sql =@@common_sql
            sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) = YEAR(GETDATE())"+@search_and
          end
        else
          #select  data follow current month & remark
          #sql = "SELECT    *
          #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
          #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
          #      AND   MONTH(dteCreated) =   MONTH(GETDATE())
          #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
          #      ORDER BY [dteCreated] DESC";
          sql = @@common_sql
          sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
          AND   MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   MONTH(GETDATE())"+@search_and
        end
      end
    else
      if (@from_date!="" && @to_date!="")
        # select data follow date & remark
        #sql = "SELECT DISTINCT  * FROM tblWSQuoteHdr
        #      WHERE  CONVERT(DATETIME,[dteCreated])<= CONVERT(DATETIME,'"+@to_date+"')+1
        #      AND    CONVERT(DATETIME,[dteCreated])>= CONVERT(DATETIME,'"+@from_date+"')
        #      AND (strSupRemark LIKE '%"+@str_search+"%' OR strQuotesNo LIKE '%"+@str_search+"%')
        #      ORDER BY dteCreated DESC";
        sql = @@common_sql
        sql =sql +  " WHERE  CONVERT(DATETIME,[dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated])<= CONVERT(DATETIME,'"+@to_date+"')+1
        AND    CONVERT(DATETIME,[dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated])>= CONVERT(DATETIME,'"+@from_date+"')"+@search_and
      else
        #select data in current month
        #sql = "SELECT   *
        #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
        #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
        #      AND   MONTH(dteCreated) =   MONTH(GETDATE())
        #      ORDER BY [dteCreated] DESC";
        sql = @@common_sql
        sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
        AND   MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   MONTH(GETDATE())
        ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC"
      end
    end

    #@quotes = Quotes.find_by_sql(sql)
    @quotes = SqlHelper.select_all('development', sql)
    @quotes = @quotes.paginate(:page => page, :per_page => row_per_page)

    #render :partial => 'search_quotes'
    render :partial => 'search_quotes_ver2'
  end

  def filter_quotes
    page = params[:page]
    @str_filter = params[:strFilter]
    if page.nil?
      page = 1
    end
    row_per_page = 10
    if @str_filter=='Current Month'
      #sql = "SELECT    *
      #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
      #      WHERE YEAR(dteCreated) =   YEAR(GETDATE())
      #      AND   MONTH(dteCreated) =   MONTH(GETDATE())
      #      ORDER BY [dteCreated] DESC";
      sql = @@common_sql
      sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
      AND   MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   MONTH(GETDATE())
      ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
    elsif @str_filter=='Current Quarter'
      time = Time.now
      month = time.month
      if (month <=3 && month>=1)
        #sql = "SELECT   *
        #    FROM [dbMPE].[dbo].[tblWSQuoteHdr]
        #    WHERE YEAR(dteCreated) =   YEAR(GETDATE())
        #    AND  ( MONTH(dteCreated) >=1 AND MONTH(dteCreated) <=3)
        #    ORDER BY [dteCreated] DESC";
        sql = @@common_sql
        sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
        AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=1 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=3)
        ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
      elsif (month <=6 && month>=4)
        #sql = "SELECT   *
        #    FROM [dbMPE].[dbo].[tblWSQuoteHdr]
        #    WHERE YEAR(dteCreated) =   YEAR(GETDATE())
        #    AND  ( MONTH(dteCreated) >=4 AND MONTH(dteCreated) <=6)
        #    ORDER BY [dteCreated] DESC";
        sql = @@common_sql
        sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
        AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=4 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=6)
        ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
      elsif (month <=9 && month >=7)
        #sql = "SELECT    *
        #    FROM [dbMPE].[dbo].[tblWSQuoteHdr]
        #    WHERE YEAR(dteCreated) =   YEAR(GETDATE())
        #    AND  ( MONTH(dteCreated) >=7 AND MONTH(dteCreated) <=9)
        #    ORDER BY [dteCreated] DESC";
        sql = @@common_sql
        sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
        AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=7 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=9)
        ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
      elsif (month <=12 && month >=10)
        #sql = "SELECT   *
        #    FROM [dbMPE].[dbo].[tblWSQuoteHdr]
        #    WHERE YEAR(dteCreated) =   YEAR(GETDATE())
        #    AND  ( MONTH(dteCreated) >=10 AND MONTH(dteCreated) <=12)
        #    ORDER BY [dteCreated] DESC";
        sql = @@common_sql
        sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) =   YEAR(GETDATE())
        AND  ( MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) >=10 AND MONTH([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) <=12)
        ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
      end
    elsif @str_filter=='Current Year'
      #sql = "SELECT    *
      #      FROM [dbMPE].[dbo].[tblWSQuoteHdr]
      #      WHERE YEAR(dteCreated) = YEAR(GETDATE())
      #      ORDER BY [dteCreated] DESC";
      sql = @@common_sql
      sql =sql +  " WHERE YEAR([dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated]) = YEAR(GETDATE())
      ORDER BY [dbMPE].[dbo].[tblWSQuoteHdr].[dteCreated] DESC";
    end
    #@quotes = Quotes.find_by_sql(sql)
    @quotes = SqlHelper.select_all('development', sql)

    @quotes = @quotes.paginate(:page => page, :per_page => row_per_page)
    render :partial => 'search_quotes_ver2'
  end

end
