$(document).on("page:change", function(){

  if($("#journal-entry").length > 0) {
    var old_cash_type_id;
    var old_date;

    total_balance();
    load_name_status();

    $(document).on("change", ".debit", function() {
      $(this).parent().parent().find(".credit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance();
      delete_row($(this));
    });

    $(document).on("change", ".credit", function() {
      $(this).parent().parent().find(".debit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance();
      delete_row($(this));
    });

    $(document).on("change", ".chart-account", function() {
      var account_type_code = ["ar", "ap"];
      var selected_account_type_code = $(this).find("option:selected").attr("type");
      var name = $(this).parents(".fields").find(".name");

      if($.inArray(selected_account_type_code, account_type_code) > -1 || $(this).val() == "") {
        name.attr("disabled", false);
      } else {
        name.select2("val", "");
        name.attr("disabled", true);
      }
    });

    $(document).on("keypress", ".debit, .credit, .statement-ending-balance", function(event) {
      if ((event.which != 46 || $(this).val().indexOf(".") != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
      }
    });

    $(document).on("click", ".btn-save", function(event) {
      validate_save(event);
    });

    $(document).on("show", ".transaction-date", function(e) {
      old_date = $(this).val();
    });

    $(document).on("hide", ".transaction-date", function(e) {
      var new_date = $(this).val();
      if(old_date !== new_date) {
        load_logbook_data();
      }
    });

    $(document).on("select2:open", ".bank_type", function(event) {
      old_cash_type_id = $(this).find("option:selected").attr("data-cash-type-id");
    });

    $(document).on("change", ".bank_type", function() {
      var new_cash_type_id = $(this).find("option:selected").attr("data-cash-type-id");
      if(old_cash_type_id != new_cash_type_id) {
        load_logbook_data();
      }else{
        load_journal_entry();
      }
    });

    $(document).on("change", ".log_book", function() {
      load_journal_entry();
    });

  }
});

function total_balance() {
  var total_debit = 0;
  var total_credit = 0;

  $(".fields").each(function() {
    var debit =  $(this).find(".debit").val().replace(/,/g, "");
    var credit = $(this).find(".credit").val().replace(/,/g, "");
    if( debit != "")
      total_debit += parseFloat(debit);
    else if( credit != "")
      total_credit += parseFloat(credit);
  });

  $(".total-debit").html(""+ $.number(total_debit, 2));
  $(".total-credit").html(""+ $.number(total_credit, 2));
}

function set_msg_valid(event, msg) {
  event.preventDefault();
  $(".journal-modal").modal("show");
  $(".invalid-msg").html(msg);
}

function validate_save(event) {
  if($(".log_book").val() == null) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.log_book_not_blank"));
  }else if(is_transaction_exist() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.trans_validate"));
  }else if(is_account_balance() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.balance_validate"));
  }else if(is_chart_account_valid() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.chart_account_validate"))
  }else if(is_name_valid() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.name_validate"));
  }
}

function is_account_balance() {
  if(parseFloat($(".total-debit").text()) - parseFloat($(".total-credit").text()) == 0)
    return true;
  return false;
}

function is_chart_account_valid() {
  var valid = true;
  $(".fields").each(function() {
    if(($(this).find(".debit").val() != "" || $(this).find(".credit").val() != "")
      && $(this).find(".chart-account").val() == "") {
      valid = false;
      return;
    }
  });
  return valid;
}

function is_name_valid() {
  var valid = true;
  var account_type_code = ["ar", "ap"];
  $(".fields").each(function() {
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("type");
    if($.inArray(selected_account_type_code, account_type_code) > -1
      && $(this).find(".name").val() == "") {
      valid = false;
      return;
    }
  });
  return valid;
}

function is_transaction_exist() {
  var exist = false;
  $(".fields").each(function() {
    if(($(this).find(".debit").val() != "") || ($(this).find(".credit").val() != "")) {
      exist = true;
      return;
    }
  });
  return exist;
}

function load_name_status() {
  var account_type_code = ["ar", "ap"];
  $(".fields").each(function() {
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("type");
    if($.inArray(selected_account_type_code, account_type_code) < 0 &&
      $(this).find(".chart-account").val() != "") {
        $(this).find(".name").select2("val", "");
        $(this).find(".name").attr("disabled", true);
    }
  });
}

function load_logbook_data() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var transaction_date = $(".transaction-date").val();
  var cash_type_id = $(".bank_type option:selected").attr("data-cash-type-id");
  $.ajax({
    type: "get",
    data: {transaction_date: transaction_date, cash_type_id: cash_type_id},
    dataType: "json",
    url: "/api/log_books?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      load_select2_with_data(data);
    }
  });
}

function reset_journal_transaction_list() {
  $("#tbl-journal-entry").find("tbody").empty();
  for(var i = 0; i < 10; i++) {
    $(".add_nested_fields").click();
  }
  load_select2_tree();
  load_select2_simple();
  $(".total-debit").html(""+ $.number(0, 2));
  $(".total-credit").html(""+ $.number(0, 2));
  $(".icon-loading").hide();
  $(".form-journal").attr("action", "/journal_entries");
  $(".form-journal input[name='_method']").val("post");
}

function load_journal_entry() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var log_book_id = $(".log_book").val();
  var bank_type_id = $(".bank_type").val();
  var transaction_date = $(".transaction-date").val();
  var cash_type_id = $(".bank_type option:selected").attr("data-cash-type-id");

  $(".icon-loading").show();

  $.ajax({
    type: "get",
    data: {log_book_id: log_book_id, bank_type_id: bank_type_id},
    dataType: "json",
    url: "/api/journal_entries?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      if(data) {
        $.get("/select_journal/"+ transaction_date +"/"+ cash_type_id +"/"+ data.id);
      }else{
        reset_journal_transaction_list();
      }
    }
  });
}

function delete_row(e) {
  var debit = e.parents(".fields").find(".debit").val();
  var credit = e.parents(".fields").find(".credit").val();
  if(debit == "" && credit == "") {
    e.parents(".fields").find("input[type=hidden]").val("1");
  }else {
    e.parents(".fields").find("input[type=hidden]").val("false");
  }
}
