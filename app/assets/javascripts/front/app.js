var app = (function($, window, document, undefined) {
    var $window = $(window),
        $document = $(document);

    var _pageInit = function() {
         _cardBoardInit();
    };

    var _cardBoardInit = function() {

        // $("article.card, article.card-details").on("click", "", function(event){
        //     event.preventDefault();

        //     var $eventTarget = $(event.target);

        //     if($eventTarget.is("a.card-favorite")) {
        //         handleCardFavorites($(this), $eventTarget);
        //     }
        //     else {
        //        window.location = $(this).data().details;
        //     }
        // });

        $("#cards-board-filter-nav > li > a").on("click", function(event){
            event.preventDefault();

            var $li = $(this).parent();
            var $ul = $li.children("ul");

            $ul.slideToggle(400, function() {
                if ($ul.is(":visible"))
                    $li.addClass("expanded");
                else
                    $li.removeClass("expanded");
            });
        });

        $(".cards-board").isotope({
            itemSelector: "article.card"
        });

        function handleCardFavorites(card, favIcon){
            var $card = card,
                $favIcon = favIcon;
            var unselected_html = '&#xE49D;'
            var selected_html = '&#xE0B5;'

            if ($favIcon.is(":animated") || $favIcon.data().busy)
                return;

            var selected = !$favIcon.is(".selected");
            $favIcon.data().busy = true;

            var anim_down = function(elem) {
                return elem.animate({ scale: 0.6 },{
                        duration: 250,
                        done: function() {
                            if (elem.data().busy)  anim_up(elem);
                            else anim_end(elem);

                }});
            }

            var anim_up = function(elem) {
                return elem.animate({ scale: 0.8 },{
                        duration: 250,
                        done: function() { anim_down(elem);
                }});
            }

            var anim_end = function(elem) {
                if (selected) {
                    elem.addClass("selected");
                    elem.html(selected_html);
                } else {
                    elem.removeClass("selected");
                    elem.html(unselected_html);
                }
                return elem.animate({ scale: 1 },{ duration: 250 });
            }

            anim_down($favIcon);

            $favIcon.prop("title", selected ? $favIcon.data().remove : $favIcon.data().add);
            $.ajax({
                url: 'http://127.0.0.1:8080/set_fav.js',
                data: {
                        selected: $favIcon.is(".selected"),
                        card: $favIcon.data().card
                },
                dataType: 'json',
                jsonp: 'callback',
                jsonpCallback: 'jsonpCallback',
                success: function(){
                    $favIcon.data().busy = false;
                },
                error: function(){
                    selected = !selected;
                    $favIcon.data().busy = false;
                }
            });
        }
    };

    var _formInit = function() {
        jQuery.extend(jQuery.validator.messages, {
            required: "Obavezno polje",
            email: "Molimo unesite ispravnu e-mail adresu"
        });

        var v = $("form").validate({
            showErrors: function(errorMap, errorList) {
                this.defaultShowErrors();
                $("label.error").attr("title", function() {return $(this).text();});
            }
        });
    };
    var dropDown = function(el) {
        var obj = this;
        this.dd = el;
        this.input = this.dd.children('input');
        this.placeholder = this.dd.children('span');
        this.opts = this.dd.find('ul.dropdown > li');
        this.val = '';
        this.index = -1;
        obj.dd.on('click', function(event){
            $(this).toggleClass('active');
            return false;
        });
        obj.opts.on('click',function(){
            var opt = $(this);
            obj.val = opt.text();
            obj.index = opt.index();
            obj.placeholder.text(obj.val);
            obj.input.val(obj.val);

        });
    };
    return {
        init: _pageInit,
        dropDown: dropDown
    };
})(jQuery, this, this.document);