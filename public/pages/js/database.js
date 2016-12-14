'use strict';
function FriendlyChat() {
  this.checkSetup();
  //this.login = document.getElementById('login');
  //this.user_id = document.getElementById('User Id');
  //this.login_password = document.getElementById('Password');
  //this.login.onclick = this.signIn.bind(this);
  this.initFirebase();
  this.formdisplay();
}

// Sets up shortcuts to Firebase features and initiate firebase auth.
FriendlyChat.prototype.initFirebase = function() {
  this.auth = firebase.auth();
  this.database = firebase.database();
  this.storage = firebase.storage();
};


FriendlyChat.prototype.formdisplay = function() {
   var ref = firebase.database().ref("Pt1/-KYkdZMy1cvtqwRz21_X");
   ref.once("value").then(function(snapshot) {
    var data = snapshot.val();
    var dict, fLen, i;
    dict = [];
    fLen = data.length;
    for (i = 0; i < fLen; i++) {
    var temp = [];
    temp = [ i,data[i] ];
    dict.push(temp);
} 
});
};

// Checks that the Firebase SDK has been correctly setup and configured.
FriendlyChat.prototype.checkSetup = function() {
  if (!window.firebase || !(firebase.app instanceof Function) || !window.config) {
    window.alert('You have not configured and imported the Firebase SDK. ' +
        'Make sure you go through the codelab setup instructions.');
  } else if (config.storageBucket === '') {
    window.alert('Your Firebase Storage bucket has not been enabled. Sorry about that. This is ' +
        'actually a Firebase bug that occurs rarely. ' +
        'Please go and re-generate the Firebase initialisation snippet (step 4 of the codelab) ' +
        'and make sure the storageBucket attribute is not empty. ' +
        'You may also need to visit the Storage tab and paste the name of your bucket which is ' +
        'displayed there.');
  }
};

window.onload = function() {
  window.friendlyChat = new FriendlyChat();
};
