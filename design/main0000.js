/* --- CUFON --- */
Cufon.set('fontFamily', 'Helios').set('fontSize', '10px').set('hover', 'true').set('separate', 'none').replace('.m1 li');



/* --- DOM READY --- */
$(function(){
    $('.placeholder').placeHolder();
    $('.hoverable').hoverable();
    $('.image.hoverable').hoverable('image');
    $('.teaser').smoothChange();
    $('.catalog-select').dropList();
    $('.m2 > ul').menu();
    $('.catalog .img a, .catalog h2 a').fancybox({
        overlayOpacity: .7,
        overlayColor: '#000',
        padding: 20
    });
});



/* --- PLUGINS --- */
// placeHolder
(function($){
    $.fn.placeHolder = function(settings){
        var config = {
            'className': 'placeholder'
        };
        if (settings) config.className = settings;

        this.each(function(){
            var label = $(this);
            var labelText = label.text();
            var input = $('#'+label.attr('for'));

            if (input.val() == '' || input.val() == labelText) {
                input.addClass(config.className).val(labelText).focus(function(){
                    input.removeClass(config.className);
                    if (input.val() == labelText) input.val('');
                }).blur(function(){
                    if (input.val() == '') input.val(labelText).addClass(config.className);
                });
            }
        });
        return this;
    };
})(jQuery);


// hoverable
(function($){
    $.fn.hoverable = function(settings){
        var config = {
            'classPrefix': ''
        };
        if (settings) config.classPrefix = settings + '-';

        this.each(function(){
            var el = $(this);

            el.hover(
                function(){
                    el.addClass(config.classPrefix + 'hover');
                },
                function(){
                    el.removeClass(config.classPrefix + 'hover');
                }
            );
        });
        return this;
    };
})(jQuery);


// smoothChange
(function($){
    $.fn.smoothChange = function(settings){
        var config = {
            'interval': 5000
        };
        if (settings) config.interval = settings;

        this.each(function(){
            var items = $('.i', this);
            var current = 0;
            var t = setInterval(function(){
                    items.eq(current).fadeOut('slow');
                    current = current+1 < items.length ? current+1 : 0;
                    items.eq(current).fadeIn('slow');
                }, config.interval);
        });
        return this;
    };
})(jQuery);


// dropList
(function($){
    $.fn.dropList = function(settings){
        var config = {
            'list': '.list',
            'menu': '.m2 > ul',
            'subMenu': '.m3'
        };
        if (settings) $.extend(config, settings);

        this.each(function(){
            var list = $(config.list, this);
            var listParent = list.parent();
            var t;

            // menu to hide
            var menu = $(config.menu);
            var menuItems = menu.children('li');
            var subMenus = $(config.subMenu, menu);

            listParent.hover(
                function(){
                    clearTimeout(t);
                    if (list.width() < listParent.width()) {
                        listParent.width(listParent.width());
                        list.width(listParent.width());
                    } else {
                        list.width(list.width());
                        listParent.width(list.width());
                    }
                    list.show();
                    listParent.addClass('hover');

                    // hide menu
                    menuItems.removeClass('hover');
                    subMenus.hide();
                    $('.rt', menu).hide();
                },
                function(){
                    t = setTimeout(function(){
                        list.hide().width('auto');
                        listParent.removeClass('hover').width('auto');
                    }, 500);
                }
            );
        });

        return this;
    };
})(jQuery);


// menu
(function($){
    $.fn.menu = function(settings){
        var config = {
            'subMenu': '.m3',
            'list': '.catalog-select .list'
        };
        if (settings) $.extend(config, settings);

        this.each(function(){
            var menu = $(this);
            var menuItems = menu.children('li');
            var subMenus = $(config.subMenu, menu);
            var subMenusParents = subMenus.parent();
            var currentIndex;
            var t;

            // list to hide
            var list = $(config.list);
            var listParent = list.parent();

            menuItems.mouseover(function(){
                var menuItemIndex = menuItems.index(this);

                if (menuItemIndex != currentIndex) {
                    menuItems.removeClass('hover');
                    subMenus.hide();
                    $('.rt', menu).hide();
                }
                currentIndex = menuItemIndex;

                // hide list
                list.hide().width('auto');
                listParent.removeClass('hover').width('auto');
            });

            subMenusParents.addClass('hasmenu').hover(
                function(){
                    var menuItem = $(this);
                    var subMenu = $(config.subMenu, menuItem);

                    clearTimeout(t);
                    menuItem.addClass('hover');
                    subMenu.show();

                    if (subMenu.width() < menuItem.width() + 26) {
                        subMenu.width(menuItem.width() + 26);
                    } else if (subMenu.width() > (menuItem.width() + 26)) {
                        if (subMenu.width() < (menuItem.width() + 26 + 12)) {
                            subMenu.width(menuItem.width() + 26 + 12);
                        }
                        $('.rt', subMenu).show();
                    } else {
                        subMenu.width(subMenu.width());
                    }
                },
                function(){
                    var menuItem = $(this);
                    var subMenu = $(config.subMenu, menuItem);

                    t = setTimeout(function(){
                        menuItem.removeClass('hover');
                        subMenu.hide();
                        $('.rt', subMenu).hide();
                    }, 500);
                }
            );
        });
        return this;
    };
})(jQuery);


// flexCols
(function($){
    $.fn.flexCols = function(settings){
        var config = {
            'classPrefix': 'cols'
        };
        if (settings) config.classPrefix = settings;


        this.each(function(){
            var container = $(this);
            var ruller = $('.ruller', container);
            var itemMinWidth = 255;
            var gapRate = 2 / 100;
            var classes = '';

            for (var i=3; i<=8; i++) {
                classes += config.classPrefix + i + ' ';
            }

            setColsNum(container, ruller, classes, itemMinWidth, gapRate);
            $(window).resize(function(){
                setColsNum(container, ruller, classes, itemMinWidth, gapRate);
            });

            function setColsNum(container, ruller, classes, itemMinWidth, gapRate) {
                var rullerWidth = ruller.width();
                if ( ( itemMinWidth * 3 ) + ( ( rullerWidth * gapRate ) * 3 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '3');
                }
                if ( ( itemMinWidth * 4 ) + ( ( rullerWidth * gapRate ) * 4 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '4');
                }
                if ( ( itemMinWidth * 5 ) + ( ( rullerWidth * gapRate ) * 5 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '5');
                }
                if ( ( itemMinWidth * 6 ) + ( ( rullerWidth * gapRate ) * 6 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '6');
                }
                if ( ( itemMinWidth * 7 ) + ( ( rullerWidth * gapRate ) * 7 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '7');
                }
                if ( ( itemMinWidth * 8 ) + ( ( rullerWidth * gapRate ) * 8 ) < rullerWidth ) {
                    container.removeClass(classes).addClass(config.classPrefix + '8');
                }
            }
        });
        return this;
    };
})(jQuery);