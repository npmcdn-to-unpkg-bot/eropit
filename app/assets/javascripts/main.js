jQuery(document).ready(function($){

	var mainHeader = $('.cd-auto-hide-header'),
		secondaryNavigation = $('.cd-secondary-nav'),
		//this applies only if secondary nav is below intro section
		belowNavHeroContent = $('.sub-nav-hero'),
		headerHeight = mainHeader.height();

	//set scrolling variables
	var scrolling = false,
		previousTop = 0,
		currentTop = 0,
		scrollDelta = 10,
		scrollOffset = 150;

	mainHeader.on('click', '.nav-trigger', function(event){
		// open primary navigation on mobile
		event.preventDefault();
		mainHeader.toggleClass('nav-open');
	});

	$(window).on('scroll', function(){
		if( !scrolling ) {
			scrolling = true;
			(!window.requestAnimationFrame)
				? setTimeout(autoHideHeader, 250)
				: requestAnimationFrame(autoHideHeader);
		}
	});

	$(window).on('resize', function(){
		headerHeight = mainHeader.height();
	});

	function autoHideHeader() {
		var currentTop = $(window).scrollTop();

		( belowNavHeroContent.length > 0 )
			? checkStickyNavigation(currentTop) // secondary navigation below intro
			: checkSimpleNavigation(currentTop);

	   	previousTop = currentTop;
		scrolling = false;
	}

	function checkSimpleNavigation(currentTop) {
		//there's no secondary nav or secondary nav is below primary nav
	    if (previousTop - currentTop > scrollDelta) {
	    	//if scrolling up...
	    	mainHeader.removeClass('is-hidden');
	    } else if( currentTop - previousTop > scrollDelta && currentTop > scrollOffset) {
	    	//if scrolling down...
	    	mainHeader.addClass('is-hidden');
	    }
	}

	function checkStickyNavigation(currentTop) {
		//secondary nav below intro section - sticky secondary nav
		var secondaryNavOffsetTop = belowNavHeroContent.offset().top - secondaryNavigation.height() - mainHeader.height();

		if (previousTop >= currentTop ) {
	    	//if scrolling up...
	    	if( currentTop < secondaryNavOffsetTop ) {
	    		//secondary nav is not fixed
	    		mainHeader.removeClass('is-hidden');
	    		secondaryNavigation.removeClass('fixed slide-up');
	    		belowNavHeroContent.removeClass('secondary-nav-fixed');
	    	} else if( previousTop - currentTop > scrollDelta ) {
	    		//secondary nav is fixed
	    		mainHeader.removeClass('is-hidden');
	    		secondaryNavigation.removeClass('slide-up').addClass('fixed');
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	}

	    } else {
	    	//if scrolling down...
	 	  	if( currentTop > secondaryNavOffsetTop + scrollOffset ) {
	 	  		//hide primary nav
	    		mainHeader.addClass('is-hidden');
	    		secondaryNavigation.addClass('fixed slide-up');
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	} else if( currentTop > secondaryNavOffsetTop ) {
	    		//once the secondary nav is fixed, do not hide primary nav if you haven't scrolled more than scrollOffset
	    		mainHeader.removeClass('is-hidden');
	    		secondaryNavigation.addClass('fixed').removeClass('slide-up');
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	}

	    }
	}

	function KeyDownFunc(e){

		var key_code = e.keyCode;
		var shift_key = e.shiftKey;

		if (shift_key) {
			if (key_code == 65) {
				location.href = "/admin";
			}
			if (key_code == 78) {
				location.href = "/articles/new";
			}
		}
	}

	if(document.addEventListener){
		document.addEventListener("keydown" , KeyDownFunc);
	}else if(document.attachEvent){
		document.attachEvent("onkeydown" , KeyDownFunc);
	}

	$('.add-favorite-btn').click(function () {
		var favoriteVideoKeys = [];
		var favoriteVideoId = [];
		for (var i = 0; i < localStorage.length; ++i) {
			favoriteVideoKeys.push(localStorage.key(i));
			var key = localStorage.key(i);
			favoriteVideoId.push(localStorage.getItem(key));
		}

		var num = localStorage.length + 1;
		var id = String($(this).data('videoId'));
		var key = "erpFavorite" + num;
		console.log(favoriteVideoId.indexOf(id));
		console.log(id);
		var item = localStorage.getItem(key);

		if(favoriteVideoId.indexOf(id) >= 0){
			addFavoriteAlert('error');
		} else {
			localStorage.setItem(key, id);
			addFavoriteAlert('success');
		};

	});

	function addFavoriteAlert(result) {
	if (result == "success") {
			$('.alert-wrapper').append('<div class="alert"><span><i class="icon ion-checkmark-circled"></i>&nbsp;お気に入りに追加しました！</span><a class="favorite-link"><i class="icon ion-star"></i>&nbsp;一覧</a></div>');
			$('.alert-wrapper').fadeIn();
			setTimeout(function(){
				$('.alert-wrapper').fadeOut();
			},3000);
		}else {
			$('.alert-wrapper').append('<div class="alert"><span class="error"><i class="icon ion-close-circled"></i>&nbsp;既に登録されています！</span><a class="favorite-link"><i class="icon ion-star"></i>&nbsp;一覧</a></div>');
			$('.alert-wrapper').fadeIn();
			setTimeout(function(){
				$('.alert-wrapper').fadeOut();
			},3000);
		}
	}

	$('.remove-favorite-btn').click(function () {
		removeFavoriteVideos();
		if(localStorage.length == 0) {
			alert('お気に入りを削除しました。');
		}
	});

	function removeFavoriteVideos() {
		localStorage.clear();
	}
});
