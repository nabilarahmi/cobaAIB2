var $jq = jQuery.noConflict();

$jq.ajaxSetup({
  contentType: "application/json; charset=utf-8"
});

function reloadPage(){
        location.reload(true);
    }

$jq(function() {
    $jq("button.btn-lg").click(function() {
        if($jq("button.btn-lg").html() == "Restart") {
            reloadPage();
        }
        else {
            console.log($jq("button.btn-lg").html())
            var sentObj
            if($jq("#answerYes").is(':checked')) {
                sentObj = 1;
            }
            else if($jq("#answerNo").is(':checked')) {
                sentObj = 0;
            }
            else {
                sentObj = null;
            }

            $jq("div.choice").removeAttr('hidden');
            $jq.post("https://nameless-retreat-24522.herokuapp.com/question", JSON.stringify({"answer": sentObj}), function( data ) {
                $jq("h2#question").html(data.question)
                $jq(".btn-lg").html(data.button);
                if(data.button == "Restart") {
                    console.log("masuk dia")
                    $jq("div.choice").hide();
                }
            }, "json" )
        }
    });
});
