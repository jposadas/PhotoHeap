function Tagger(feedbackID, containerID, relX, relY, width, height) {
	
	this.isMouseDown = false;
	this.feedbackElement = document.getElementById(feedbackID);
	this.containerElement = document.getElementById(containerID);

	this.relX = document.getElementById(relX);
	this.relY = document.getElementById(relY);
	this.formWidth = document.getElementById(width);
	this.formHeight = document.getElementById(height);


	preventImgDefault(this.containerElement.children[0]);

	var obj = this;

	this.containerElement.onmousedown = function(event) {
        obj.mouseDown(event);
    };

};

function prevDefault(evt) {
 	evt.preventDefault();
};

function preventImgDefault(img) {
	img.addEventListener('mousedown', prevDefault);
};

Tagger.prototype.mouseDown =  function(event) {
	
	var obj = this;
	this.isMouseDown = true;

	this.initialX = event.pageX - this.containerElement.offsetLeft;
	this.initialY = event.pageY - this.containerElement.offsetTop;

	this.feedbackElement.style.left = this.initialX + "px";
	this.feedbackElement.style.top = this.initialY + "px";
	this.feedbackElement.style.visibility = 'hidden';

	this.relX.value = this.initialX;
	this.relY.value = this.initialY;

	this.containerElement.onmousemove = function(event) {
    	obj.mouseMove(event);
    }
    this.containerElement.onmouseup = function(event) {
        obj.mouseUp(event);
    }
};

Tagger.prototype.mouseMove = function(event) {

		var localWidth = (event.pageX - this.containerElement.offsetLeft) - this.initialX;
		var localHeight = (event.pageY - this.containerElement.offsetTop) - this.initialY;

		if (localWidth < 0) {
			this.feedbackElement.style.left = (this.initialX + localWidth) + "px";
			this.relX.value = this.initialX + localWidth;
	
		}
		if (localHeight < 0) {
			this.feedbackElement.style.top = (this.initialY + localHeight) + "px";
			this.relY.value = this.initialY + localHeight;
		}

		this.feedbackElement.style.width = Math.abs(localWidth) + "px";
		this.feedbackElement.style.height = Math.abs(localHeight) + "px";
		this.feedbackElement.style.visibility = 'visible';

		this.formWidth.value = Math.abs(localWidth);
		this.formHeight.value = Math.abs(localHeight);

};

Tagger.prototype.mouseUp = function(event) {

	this.isMouseDown = false;
	this.containerElement.onmousemove = null;

};
