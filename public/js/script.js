//Counter

$(document).ready(function() {

	$(".counter").countdown({
		date: "july 6, 2013", //Counting TO a date
		onChange: function( event, timer ){
		
		},
		onComplete: function( event ){
		
			$(this).html("Completed");
		},
		leadingZero: true,
		direction: "down"
	});

//Contact form

  $('#submit').click(function () {
    var email = $('input[name=email]');
    var data = 'email=' + email.val() ;
            $.ajax({
            //this is a php file that processes the data and send mail
            url: "amls.php",    
            type: "POST",
            data: data,        
            //Do not cache the page
            cache: false,
            //success
            success: function (data) {
                $('#msgTxt').html(data);  
     
            }        
        });
          
        //cancel the submit button default behaviours
        return false;
    });    

});//document).ready


//Digit animation

var d = 06,          //Number displayed on web page
    step = 10,       //step numbers to get final number
    border = 27,    // if d less or equal border, then then counter will be decreased, if larger increase
    t = 20,          //animation speed in milliseconds
    per = 80,       //animation boost in milliseconds
    divDate,
    c = d;


if(c <= border)
    c += step;
else
    c -= step;

//функция изменения счетчика

function changeNum(){

    if(d <= border)
        c--;
    else
        c++;
    divDate.innerHTML = c;
    t += per;
    if(c != d)
        setTimeout(changeNum, t);
}

//функция расчета задержки времени перед анимацией шрифта
function setDelay(){
    var a = 0;
    var b = t;
    for(var i = 1;i < step;i++){
        b = b + per;
        a += b;
    }
    return a;
};

window.onload = function(){
    divDate = document.getElementById("clock");
    //функция анимации шрифта
	$("#clock").delay(setDelay()).fadeOut(1000).fadeIn();

    changeNum();
}

