$(document).on("ready", function(){
  if($("#item-list").length > 0){

    load_selectize_simple(".item-list-type");
    load_income_other_income("#chart-account");
    load_chart_account("#cogs-account");
    load_income_other_income("#income-account");
    load_selectize_simple(".customer-vender");
    load_selectize_simple(".unit-of-measure");

    hide_show_field();

    $(".item-list-type").on("change", function(){
      $("#chart-account")[0].selectize.destroy();
      var value = $(".item-list-type option:selected").text().toLowerCase();
      if(value == "service") {
        load_income_other_income("#chart-account");
      } else if(value == "inventory part"){
        load_other_current_asset("#chart-account");
      } else {
        load_chart_account("#chart-account")
      }
      hide_show_field();
    });

    function hide_show_field() {
      hide_field();
      var item_list_type = $(".item-list-type option:selected").text().toLowerCase();
      if(item_list_type == "inventory part") {
        $(".manufacturer").show();
        $(".other-field").show();
        $(".price").show();
      } else if (item_list_type == "non-inventory part") {
        $(".manufacturer").show();
      } else if (item_list_type == "service") {
        $(".price").show();
      }
    }

    function hide_field() {
      $(".manufacturer").hide();
      $(".other-field").hide();
      $(".price").hide();
    }

    function load_chart_account(selector) {
      $(""+selector).selectize({
        onInitialize: function () {
          var s = this;
          this.revertSettings.$children.each(function () {
            $.extend(s.options[this.value], $(this).data());
          });
          s.positionDropdown();
        },
        dropdownParent: "body",
        render: {
          option: function(item, escape) {
            var result = ("<div class='row'>" +
              "<div class='col-md-7'>" + item.text + "</div>" +
              "<div class='col-md-5'>" + item.type + "</div>" +
              "</div>");
              return result;
          }
        }
      });
    }

    function load_income_other_income(selector) {
      $(""+selector).selectize({
        onInitialize: function () {
          var s = this;
          this.revertSettings.$children.each(function () {
            $.extend(s.options[this.value], $(this).data());
          });
          s.positionDropdown();
        },
        dropdownParent: "body",
        render: {
          option: function(item, escape) {
            var type = item.type.toLowerCase();
            if(type != "income" && type != "other income") return "";
            var result = ("<div class='row'>" +
              "<div class='col-md-7'>" + item.text + "</div>" +
              "<div class='col-md-5'>" + type + "</div>" +
              "</div>");
              return result;
          }
        }
      });
    }

    function load_other_current_asset(selector) {
      $(""+selector).selectize({
        onInitialize: function () {
          var s = this;
          this.revertSettings.$children.each(function () {
            $.extend(s.options[this.value], $(this).data());
          });
          s.positionDropdown();
        },
        dropdownParent: "body",
        render: {
          option: function(item, escape) {
            var type = item.type.toLowerCase();
            if(type != "other current asset") return "";
            var result = ("<div class='row'>" +
              "<div class='col-md-7'>" + item.text + "</div>" +
              "<div class='col-md-5'>" + type + "</div>" +
              "</div>");
              return result;
          }
        }
      });
    }
  }
});
