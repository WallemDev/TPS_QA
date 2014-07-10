// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// require twitter/bootstrap
//= require_tree .
//require moment ;
//require bootstrap-datetimepicker  ;

// check Login
function CheckLogin() {
//    alert('CheckLogin');
    var user_name = $('#login_username').val();
    var password = $('#login_password').val();
    $.ajax(
        {
            url: '/logins/check_login',
            type: 'GET',
            data: {'username': user_name, 'password': password},
            success: function (data) {
                alert('ok');
            },
            error: function (data) {

            }
        }
    );
}

function CancelLogin() {

}

function SearchQuotes() {
    var from_date = $('#from_date').find('input').val();
    var to_date = $('#to_date').find('input').val();
    var filter_by = $('#filter_option :selected').text();
    var strSearch = $('#search_quote').val();
    var filter = '1';
    if (strSearch.length > 100) {
        alert('Search string should not exceed 100 characters.');
        return false;
    }
    var load = new ajaxLoader('body', {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.7'});
    $.ajax(
        {
            url: 'quotes/search_quotes',
            type: 'GET',
            data: {'str_search': (strSearch), 'filter': filter, 'filter_by': filter_by, 'from_date': from_date, 'to_date': to_date},
            success: function (data) {
                if (load) load.remove();
                //alert(data);
                $('#tbl_quotes').html(data);

            },
            error: function (data) {

            }
        }
    );
    //cmsam clear tbl Quotes details
    $.ajax({
        url: '/quotes/reload_quote_details',
        type: 'GET',
        success: function (data) {
            $('#partial_quotedetails').html(data);
        }
    });
}
// Load ajax data
function loadAjaxData(url, elementID) {
    //$("#"+elementID+'-status').html('<img src="/assets/loading.gif" border="0" valign="middle" width="16" height="16" /> loading, please wait...');
    var loading = new ajaxLoader('body', {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.7'});

    $.ajax(
        {
            url: url,
            type: "GET",
            data: {'is_partial': true},
            success: function (data) {
                if (loading) loading.remove();
                $("#" + elementID).html(data);
                //$("#"+elementID+'-status').html('');
            }
        }
    );
    //cmsam clear tbl Quotes details
    $.ajax({
        url: '/quotes/reload_quote_details',
        type: 'GET',
        success: function (data) {
            $('#partial_quotedetails').html(data);
        }
    });
}

function show_details(strQuotesNo, intQteVerNo, tr) {
    //Save id of current tr to hidden field.
    var tr_id = tr.attr('id');
    $('#tr_id').val(tr_id);
    //tr.find('td:first').html('Change');
    //alert(tr.find('td:first').html());
    //cmsam add highlight
    var table = $(tr).parent().parent();
    $(table).find('tr').each(function () {
        $(this).removeClass('highlight');
    });
    tr.addClass('highlight');
    var load = new ajaxLoader('body', {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.7'});
    $.ajax(
        {
            url: '/quote_details/show',
            type: "GET",
            data: "strQuotesNo=" + strQuotesNo + "&intQteVerNo=" + intQteVerNo,
            success: function (data) {
                if (load) load.remove();
                $('#partial_quotedetails').html(data);
            }
        }
    );
}

function filter_quotes(strFilter) {
    if (strFilter != "") {
        var load = new ajaxLoader('body', {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.7'});
        $.ajax(
            {
                url: '/quotes/filter_quotes',
                type: "GET",
                data: "strFilter=" + strFilter,
                success: function (data) {
                    if (load) load.remove();
                    $('#tbl_quotes').html(data);
                }
            }
        );
        //cmsam clear tbl Quotes details
        $.ajax({
            url: '/quotes/reload_quote_details',
            type: 'GET',
            success: function (data) {
                $('#partial_quotedetails').html(data);
            }
        });
    }
}

function CheckORUncheck() {

    var isChecked = $('#cbCheckOrUncheck').is(':checked');
    if (isChecked) {
        $('#tbl_quotes_details > tbody  > tr').each(function () {
            var CheckBox = $(this).find('td:nth-child(7) > input:checkbox');
            if (CheckBox.length > 0) {

                CheckBox.prop('checked', true)
            }
        })
    }
    if (!isChecked) {
        $('#tbl_quotes_details > tbody  > tr').each(function () {
            var CheckBox = $(this).find('td:nth-child(7) > input:checkbox');
            if (CheckBox.length > 0) {
                CheckBox.prop('checked', false);
            }
        })
    }

}

function save_data(id) {
    //Get Id of current row select
    var CurrentRowSelect = $('#tr_id').val();

    var numberRow = 0;
    var numberRowOK = 0;
    var numberRowNotOK = 0;

    var maxCountChecked = 0;
    var count = 0;
    var isRenderView = 0;

    var static_strQuotesNo = '';
    var static_intQteVerNo = '';
    $('#tbl_quotes_details > tbody  > tr').each(function () {
        var cb_detail = $(this).find('.cb_details');
        if (cb_detail.is(':checked')) {
            maxCountChecked++;
        }
    })

    $('#tbl_quotes_details > tbody  > tr').each(function () {
        var cb_detail = $(this).find('.cb_details');
        if (cb_detail.is(':checked')) {
            count++;
            var QuoteVersion = $(this).find('.QteVerNo');
            var QuoteNo = $(this).find('.QuotesNo');
            var RQLineNo = $(this).find('.RQLineNo');
            var strQuotesNo = QuoteNo.val();
            var intQteVerNo = QuoteVersion.val();
            //cmsam
            static_strQuotesNo = strQuotesNo;
            static_intQteVerNo = intQteVerNo;

            var intRQLineNo = RQLineNo.val();
            if (id == "btnOK") {
                var intMarkedValue = 1;
            }
            else {
                var intMarkedValue = 0;
            }
            var intMailedValue = 0;
            if (count == maxCountChecked) {
                isRenderView = 1
            }

            var load = new ajaxLoader('body', {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.2'});
            //Call Ajax to save into  database
            $.ajax(
                {
                    url: '/confirm_quotes/create',
                    type: "GET",
//                    async: false,
                    data: "strQuotesNo=" + strQuotesNo + "&intQteVerNo=" + intQteVerNo + "&is_render_view=" + isRenderView
                        + "&intRQLineNo=" + intRQLineNo + "&intMarkedValue=" + intMarkedValue + "&intMailedValue=" + intMailedValue,
                    success: function (data) {
                        if (data != "0") {
                            if (load) load.remove();
                            $('#partial_quotedetails').html(data);

                            $('#tbl_quotes_details > tbody  > tr').each(function () {
                                numberRow++
                            })

                            $('#tbl_quotes_details > tbody  > tr').each(function () {

                                var value = $(this).find('td:nth-child(6)').html()
                                if (value == 'OK') {
                                    numberRowOK++
                                }
                                if (value == 'Not OK') {
                                    numberRowNotOK++
                                }
                            })
                            if (numberRowOK == numberRow) {
                                $('#' + CurrentRowSelect).find('td:first').html('OK');
                            }
                            else {
                                if (numberRowNotOK + numberRowOK == numberRow)
                                    $('#' + CurrentRowSelect).find('td:first').html('NOT OK');
                                else
                                    $('#' + CurrentRowSelect).find('td:first').html('NOT DONE');
                            }
                        }
                    }
                }
            );
        }
    })
    if (static_strQuotesNo != '') {
        if (id != 'btnOK') {
            //send mail here
            $.ajax(
                {
                    url: '/confirm_quotes/send_mail_for_quote',
                    type: "GET",
                    async: false,
                    data: {'static_strQuotesNo': static_strQuotesNo, 'static_intQteVerNo': static_intQteVerNo},
                    success: function (data) {

                    }
                }
            );
        }
    }
}