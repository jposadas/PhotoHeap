function UserFinder(srcDiv, tagsDiv, commDiv) {

	this.tagsDiv = document.getElementById(tagsDiv);
	this.commDiv = document.getElementById(commDiv);

	var sourceElem = document.getElementById(srcDiv);



	this.xhr = new XMLHttpRequest();

	var obj = this;

	sourceElem.onkeyup = function(event) {

		var text = sourceElem.value;

		if (text.length > 0) {

			obj.xhr.onreadystatechange = function() {			
				obj.xhrHandler();
			}


			var url = "/users/search/?text=" + text;
			console.log(url);

			obj.xhr.open("GET", url);

			// obj.xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			// obj.xhr.setRequestHeader('X-Requested-With','XMLHttpRequest');

			obj.xhr.send();

		} else {
			obj.tagsDiv.innerHTML = "";
			obj.commDiv.innerHTML = "";
		}
	}

}

UserFinder.prototype.xhrHandler = function() {
	if(this.xhr.readyState != 4) {
		return;
	}

	if (this.xhr.status != 200) {    
      	console.log("error displaying results");
  	}  

  	var response = JSON.parse(this.xhr.responseText);

  	
  	
  	//Update HTML
  	// console.log(response);

  	var tagsArr = new Array();
  	var commArr = new Array();

  	for (var i = 0; i < response.length; i++) {

  		if (response[i].name == "comment") {
  			commArr.push(response[i]);
  		} else {
  			tagsArr.push(response[i]);
  		}

  	}


  	// console.log(tagsArr);
  	// console.log(commArr);

  	generateHTML(this.tagsDiv, this.commDiv, commArr, tagsArr);


};



function generateHTML(tagsDiv, commDiv, commArr, tagsArr) {

	console.log(tagsArr);
	console.log(commArr);

	tagsDiv.innerHTML = "";
	commDiv.innerHTML = "";


	if(tagsArr.length > 0) {

		
		var h2 = tagsDiv.appendChild(document.createElement("H3"));
		h2.innerHTML = "Tagged";
		
		for(var i = 0; i < tagsArr.length; i++){			
			if(i % 4 == 0 && i != 0) {
				commDiv.appendChild(document.createElement("BR"));
			}
			var a = commDiv.appendChild(document.createElement("A"));
			a.setAttribute("href", "/photos/index/" + tagsArr[i].user_id + "#" + tagsArr[i].photo_id);
			var img = a.appendChild(document.createElement("IMG"));
			img.setAttribute("src", "http://www.stanford.edu/~jposadas/images/" + tagsArr[i].filename);
			img.setAttribute("class", "thumbnail");
		}
	}



	if(commArr.length > 0) {

		commDiv.appendChild(document.createElement("HR"));
		var h2 = commDiv.appendChild(document.createElement("H3"));
		h2.innerHTML = "Commented";
		
		for(var i = 0; i < commArr.length; i++){

			if(i % 4 == 0 && i != 0) {
				commDiv.appendChild(document.createElement("BR"));
			}

			var a = commDiv.appendChild(document.createElement("A"));
			a.setAttribute("href", "/photos/index/" + commArr[i].user_id + "#" + commArr[i].photo_id);
			var img = a.appendChild(document.createElement("IMG"));
			img.setAttribute("src", "/images/" + commArr[i].filename);
			img.setAttribute("class", "thumbnail");
			
		}
	}
	
	
};







