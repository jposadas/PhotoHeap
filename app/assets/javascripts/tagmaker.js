function GenerateTag(containerID, textID, relx, rely, width, height, name) {

	var container = document.getElementById(containerID);
	var text = document.getElementById(textID);
	var length = container.children.length;

	container.appendChild(document.createElement("DIV"));

	var elem = container.children[length];

	elem.setAttribute("class", "tagDisplay");
	elem.style.left = relx + "px";
	elem.style.top = rely + "px";
	elem.style.width = width + "px";
	elem.style.height = height + "px";

	elem.onmouseover = function(event) {
		text.innerHTML = "You are looking at <span class='taggedName'>" + name + "!</span>";
	};

	elem.onmouseout = function(event) {
		text.innerHTML = "";
	};

};