$(function () {
    var input = '', correct = '1593';
    var dots = document.querySelectorAll('.dot');
    $('.number').unbind().click(function (e) {
        $(this).addClass('grow');
        input += $(this).html();
        $(dots[input.length - 1]).addClass('active');
        if (input.length >= 4) {
            if (input !== correct) {
                $('.dot').addClass('wrong');
            } else {
                $('.dot').addClass('correct');
            }
            setTimeout(function () {
                $('.dot').removeClass('correct');
                $('.dot').removeClass('wrong');
                $('.dot').removeClass('active');
                input = '';
            }, 900);
        }
    });
    $('body').unbind().keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if ((keycode >= 48) && (keycode <= 57)) {
            switch (keycode) {
                case 48:
                    $('.0').click();
                    break;
                case 49:
                    $('.1').click();
                    break;
                case 50:
                    $('.2').click();
                    break;
                case 51:
                    $('.3').click();
                    break;
                case 52:
                    $('.4').click();
                    break;
                case 53:
                    $('.5').click();
                    break;
                case 54:
                    $('.6').click();
                    break;
                case 55:
                    $('.7').click();
                    break;
                case 56:
                    $('.8').click();
                    break;
                case 57:
                    $('.9').click();
                    break;
            }
        }
    });
});