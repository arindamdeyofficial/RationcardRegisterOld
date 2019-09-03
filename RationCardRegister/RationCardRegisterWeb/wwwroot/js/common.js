$(function () {
    $('.ValidateAdhar').blur(function (e) {
        if (!validateAdhar($(this).val())) {
            alert('Adhar number not valid');
        }
    });
    //onblur check for maxlength and minlength
    //otherwise these properties checks it on submit time
    $('input[minlength], input[maxlength]').blur(function (e) {
        var minlength = $(this).attr('minlength');
        var maxlength = $(this).attr('maxlength');
        if ((minlength != undefined) && (minlength > 0)) {
            if ($(this).val().length < minlength) {
                alert('Please enter minimum of ' + minlength + ' characters');
            }
        }
        if (maxlength != undefined) {
            if ($(this).val().length > maxlength) {
                alert('Please enter not more than ' + maxlength + ' characters');
            }
        }
    });
});
